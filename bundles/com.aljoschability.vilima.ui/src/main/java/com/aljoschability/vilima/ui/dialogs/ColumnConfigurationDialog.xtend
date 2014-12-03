package com.aljoschability.vilima.ui.dialogs

import com.aljoschability.vilima.VilimaColumnConfiguration
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.VilimaImages
import com.aljoschability.vilima.ui.columns.ColumnCategoryExtension
import com.aljoschability.vilima.ui.columns.ColumnExtension
import com.aljoschability.vilima.ui.extensions.SwtExtension
import java.util.Map
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.dialogs.TitleAreaDialog
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Shell

import static com.aljoschability.vilima.ui.dialogs.ColumnConfigurationDialog.*
import com.aljoschability.vilima.VilimaColumn
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.jface.viewers.IStructuredSelection
import com.aljoschability.vilima.VilimaFactory
import org.eclipse.swt.dnd.DND
import org.eclipse.swt.dnd.Transfer

class ColumnConfigurationDialog extends TitleAreaDialog {
	val static COLUMN_WIDTH_ACTIVE_TITLE = "COLUMN_WIDTH_ACTIVE_TITLE"
	val static COLUMN_WIDTH_ACTIVE_WIDTH = "COLUMN_WIDTH_ACTIVE_WIDTH"
	val static SASH_WIDTH = "SASH_WIDTH"

	extension SwtExtension = SwtExtension::INSTANCE

	VilimaColumnConfiguration configuration
	Map<String, ColumnExtension> availableColumns = newLinkedHashMap

	IDialogSettings settings

	SashForm sash
	TreeViewer activeViewer
	TreeViewer inactiveViewer

	new(Shell shell, VilimaColumnConfiguration configuration) {
		super(shell)

		this.configuration = configuration

		availableColumns = Activator::get.columnRegistry.columns

		initializeDialogSettings()
	}

	override protected createDialogArea(Composite parent) {
		val area = super.createDialogArea(parent) as Composite

		sash = new SashForm(area, SWT::HORIZONTAL)
		sash.layoutData = newGridData(true, true)

		// available part
		val inactiveComposite = new Composite(sash, SWT::NONE)
		inactiveComposite.layout = newSwtGridLayout

		createInactiveViewer(inactiveComposite)

		// active part
		val activeComposite = new Composite(sash, SWT::NONE)
		activeComposite.layout = newSwtGridLayout(2)

		createControls(activeComposite)

		createActiveViewer(activeComposite)

		val sashWeights = settings.getArray(SASH_WIDTH)
		sash.weights = #[Integer.parseInt(sashWeights.get(0)), Integer.parseInt(sashWeights.get(1))]

		// title
		title = "Configure Columns"
		message = "Configure the columns that should be shown."

		return area
	}

	def private void createInactiveViewer(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = newSwtGridLayout
		group.layoutData = newGridData(true, true)
		group.text = "Available Columns"

		inactiveViewer = new TreeViewer(group, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::SINGLE))
		inactiveViewer.tree.layoutData = newGridData(true, true)

		inactiveViewer.autoExpandLevel = TreeViewer::ALL_LEVELS
		inactiveViewer.contentProvider = new ColumnExtensionsContentProvider
		inactiveViewer.labelProvider = new LabelProvider {
			override getText(Object element) {
				switch element {
					ColumnCategoryExtension: element.name
					ColumnExtension: element.name
					default: super.getText(element)
				}
			}

			override getImage(Object element) {
				switch element {
					ColumnCategoryExtension: {
						if(element.imagePath != null) {
							return Activator::get.getImage('''«element.namespace»/«element.imagePath»''')
						}
					}
					default:
						super.getImage(element)
				}
			}
		}

		inactiveViewer.input = Activator::get.columnRegistry.columnCategories
	}

	def private void createActiveViewer(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = newSwtGridLayout
		group.layoutData = newGridData(true, true)
		group.text = "Active Columns"

		activeViewer = new TreeViewer(group, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::SINGLE))
		activeViewer.tree.layoutData = newGridData(true, true)
		activeViewer.tree.headerVisible = true
		activeViewer.tree.linesVisible = true

		activeViewer.contentProvider = new VilimaColumnsContentProvider

		// column
		val columnColumn = new TreeViewerColumn(activeViewer, SWT::LEAD)
		columnColumn.column.text = "Column"
		columnColumn.column.width = settings.getInt(COLUMN_WIDTH_ACTIVE_TITLE)
		columnColumn.column.resizable = true
		columnColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				if(element instanceof VilimaColumn) {
					return availableColumns.get(element.id).name
				}
				return super.getText(element)
			}
		}

		val widthColumn = new TreeViewerColumn(activeViewer, SWT::CENTER)
		widthColumn.column.text = "Width"
		widthColumn.column.width = settings.getInt(COLUMN_WIDTH_ACTIVE_WIDTH)
		widthColumn.column.resizable = true
		widthColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				if(element instanceof VilimaColumn) {
					return String.valueOf(element.width)
				}
				return super.getText(element)
			}

		}
		widthColumn.editingSupport = new WidthColumnEditingSupport(activeViewer)

		activeViewer.input = configuration
	}

	def private void createControls(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layoutData = newGridData
		composite.layout = newGridLayout

		// add or remove columns
		val moveComposite = new Composite(composite, SWT::NONE)
		moveComposite.layoutData = newGridData
		moveComposite.layout = newSwtGridLayout

		val addButton = new Button(moveComposite, SWT::PUSH)
		addButton.layoutData = newGridData
		addButton.image = VilimaImages::image(VilimaImages::TRIANGLE_RIGHT)
		addButton.toolTipText = "Add Selected Column"
		addButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					val before = configuration.columns.size

					val selection = inactiveViewer.selection as IStructuredSelection
					selection.iterator.forEach [
						if(it instanceof ColumnExtension) {
							val column = VilimaFactory::eINSTANCE.createVilimaColumn
							column.id = it.id
							column.width = it.width
							configuration.columns += column
						}
					]

					if(configuration.columns.size != before) {
						activeViewer.refresh
					}
				}
			})

		val removeButton = new Button(moveComposite, SWT::PUSH)
		removeButton.layoutData = newGridData
		removeButton.image = VilimaImages::image(VilimaImages::TRIANGLE_LEFT)
		removeButton.toolTipText = "Remove Selected Column"
		removeButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					val before = configuration.columns.size

					val selection = activeViewer.selection as IStructuredSelection
					for (element : selection.toArray) {
						if(element instanceof VilimaColumn) {
							configuration.columns -= element
						}
					}

					if(configuration.columns.size != before) {
						activeViewer.refresh
					}
				}
			})

		// change order of active columns
		val orderComposite = new Composite(composite, SWT::NONE)
		orderComposite.layoutData = newGridData
		orderComposite.layout = newSwtGridLayout

		val upButton = new Button(orderComposite, SWT::PUSH)
		upButton.layoutData = newGridData
		upButton.image = VilimaImages::image(VilimaImages::TRIANGLE_UP)
		upButton.toolTipText = "Move Selected Column Up"
		upButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					val selection = activeViewer.selection as IStructuredSelection

					var changed = false

					for (element : selection.toArray) {
						val index = configuration.columns.indexOf(element)
						configuration.columns.move(index - 1, element as VilimaColumn)
						changed = true
					}

					if(changed) {
						activeViewer.refresh
					}
				}
			})

		val downButton = new Button(orderComposite, SWT::PUSH)
		downButton.layoutData = newGridData
		downButton.image = VilimaImages::image(VilimaImages::TRIANGLE_DOWN)
		downButton.toolTipText = "Move Selected Column Down"
		downButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					val selection = activeViewer.selection as IStructuredSelection

					var changed = false

					for (element : selection.toArray) {
						val index = configuration.columns.indexOf(element)
						configuration.columns.move(index + 1, element as VilimaColumn)
						changed = true
					}

					if(changed) {
						activeViewer.refresh
					}
				}
			})
	}

	def private void initializeDialogSettings() {
		val bundleSettings = Activator::get.dialogSettings
		settings = bundleSettings.getSection(ColumnConfigurationDialog.name)
		if(settings == null) {
			settings = bundleSettings.addNewSection(ColumnConfigurationDialog.name)

			settings.put(SASH_WIDTH, #["2", "3"])
			settings.put(COLUMN_WIDTH_ACTIVE_TITLE, 160)
			settings.put(COLUMN_WIDTH_ACTIVE_WIDTH, 47)
		}
	}

	override close() {

		// store sash weights
		if(sash != null && !sash.disposed) {
			settings.put(SASH_WIDTH, #[String::valueOf(sash.weights.get(0)), String::valueOf(sash.weights.get(1))])
		}

		// store active columns viewer column widths
		if(activeViewer != null && activeViewer.tree != null && !activeViewer.tree.disposed) {
			val columns = activeViewer.tree.columns
			settings.put(COLUMN_WIDTH_ACTIVE_TITLE, columns.get(0).width)
			settings.put(COLUMN_WIDTH_ACTIVE_WIDTH, columns.get(1).width)
		}

		return super.close()
	}

	override protected getDialogBoundsSettings() { settings }

	override protected isResizable() { true }
}
