package com.aljoschability.vilima.ui.dialogs

import com.aljoschability.vilima.VilimaColumn
import com.aljoschability.vilima.VilimaColumnConfiguration
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.VilimaImages
import com.aljoschability.vilima.ui.columns.MkFileColumnCategoryExtension
import com.aljoschability.vilima.ui.columns.MkFileColumnExtension
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import com.aljoschability.vilima.ui.extensions.SwtExtension
import java.util.Collection
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.dialogs.TitleAreaDialog
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Shell

import static extension com.aljoschability.vilima.ui.dialogs.ColumnConfigurationDialog.*

class ColumnConfigurationDialog extends TitleAreaDialog {
	val static COLUMN_WIDTH_ACTIVE_TITLE = "COLUMN_WIDTH_ACTIVE_TITLE"
	val static COLUMN_WIDTH_ACTIVE_WIDTH = "COLUMN_WIDTH_ACTIVE_WIDTH"
	val static SASH_WIDTH = "SASH_WIDTH"

	extension SwtExtension = SwtExtension::INSTANCE

	MkFileColumnRegistry registry

	VilimaColumnConfiguration configuration

	IDialogSettings settings

	SashForm sash
	TreeViewer activeViewer
	TreeViewer inactiveViewer

	new(Shell shell, MkFileColumnRegistry registry, VilimaColumnConfiguration configuration) {
		super(shell)

		this.registry = registry
		this.configuration = configuration

		initializeDialogSettings()
	}

	override protected createDialogArea(Composite parent) {
		val area = super.createDialogArea(parent) as Composite

		sash = new SashForm(area, SWT::HORIZONTAL)
		sash.layoutData = newGridData(true, true)

		// available part
		val inactiveComposite = new Composite(sash, SWT::NONE)
		inactiveComposite.layout = newGridLayoutSwt

		createInactiveViewer(inactiveComposite)

		// active part
		val activeComposite = new Composite(sash, SWT::NONE)
		activeComposite.layout = newGridLayoutSwt(2)

		createControls(activeComposite)

		createActiveViewer(activeComposite)

		val sashWeights = settings.getArray(SASH_WIDTH)
		sash.weights = #[Integer.parseInt(sashWeights.get(0)), Integer.parseInt(sashWeights.get(1))]

		// title
		title = "Configure Columns"
		message = "Configure the columns that should be shown."

		return area
	}

	override protected createButtonsForButtonBar(Composite parent) {
		val exportButton = createButton(parent, 50, "Export", false)
		exportButton.addSelectionListener(
			new SelectionAdapter {
				FileDialog dialog

				override widgetSelected(SelectionEvent e) {
					if(dialog == null) {
						dialog = new FileDialog(shell, SWT::SAVE)
						dialog.fileName = "columns.vfcc"
						dialog.filterExtensions = #["*.vfcc", "*.*"]
						dialog.filterIndex = 0
						dialog.filterNames = #["Vilima File Column Configuration", "All Files"]
						dialog.text = "Export Column Configuration"
						dialog.overwrite = true
					}

					val result = dialog.open
					if(result != null) {
						saveConfiguration(result)
					}
				}
			})

		val importButton = createButton(parent, 60, "Import", false)
		importButton.addSelectionListener(
			new SelectionAdapter {
				FileDialog dialog

				override widgetSelected(SelectionEvent e) {
					if(dialog == null) {
						dialog = new FileDialog(shell, SWT::OPEN)
						dialog.filterExtensions = #["*.vfcc", "*.*"]
						dialog.filterIndex = 0
						dialog.filterNames = #["Vilima File Column Configuration", "All Files"]
						dialog.text = "Import Column Configuration"
					}

					val result = dialog.open
					if(result != null) {
						loadConfiguration(result)
					}
				}
			})

		super.createButtonsForButtonBar(parent)
	}

	def private void saveConfiguration(String path) {
		val realPath = if(path.endsWith(".vfcc")) {
				path
			} else {
				path + ".vfcc"
			}
		val uri = URI::createFileURI(realPath)
		val res = new XMIResourceImpl(uri)
		res.contents += configuration
		res.save(null)
	}

	def private void loadConfiguration(String path) {
		val uri = URI::createFileURI(path)
		val res = new XMIResourceImpl(uri)
		res.load(null)

		var VilimaColumnConfiguration loaded = null
		for (content : res.contents) {
			if(content instanceof VilimaColumnConfiguration) {
				loaded = content
			}
		}

		configuration = loaded
		activeViewer.input = configuration
		inactiveViewer.refresh
	}

	def private void createInactiveViewer(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = newGridLayoutSwt
		group.layoutData = newGridData(true, true)
		group.text = "Available Columns"

		inactiveViewer = new TreeViewer(group, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::MULTI))
		inactiveViewer.tree.layoutData = newGridData(true, true)

		inactiveViewer.autoExpandLevel = TreeViewer::ALL_LEVELS
		inactiveViewer.contentProvider = new ColumnExtensionsContentProvider
		inactiveViewer.labelProvider = new LabelProvider {
			override getText(Object element) {
				switch element {
					MkFileColumnCategoryExtension: element.name
					MkFileColumnExtension: element.name
					default: super.getText(element)
				}
			}

			override getImage(Object element) {
				switch element {
					MkFileColumnCategoryExtension: {
						if(element.imagePath != null) {
							return Activator::get.getImage('''«element.namespace»/«element.imagePath»''')
						}
					}
					default:
						super.getImage(element)
				}
			}
		}
		inactiveViewer.addDoubleClickListener([e|handleAddColumns(e.selection.selectedColumnExtension)])

		inactiveViewer.input = registry.columnCategories
	}

	def private void createActiveViewer(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = newGridLayoutSwt
		group.layoutData = newGridData(true, true)
		group.text = "Active Columns"

		activeViewer = new TreeViewer(group, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::MULTI))
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
					return registry.columns.get(element.id).name
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

		activeViewer.addDoubleClickListener([e|handleRemoveColumns(e.selection.selectedVilimaColumns)])

		activeViewer.input = configuration
	}

	def private void createControls(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layoutData = newGridData
		composite.layout = newGridLayout

		// add or remove columns
		val moveComposite = new Composite(composite, SWT::NONE)
		moveComposite.layoutData = newGridData
		moveComposite.layout = newGridLayoutSwt

		val addButton = new Button(moveComposite, SWT::PUSH)
		addButton.layoutData = newGridData
		addButton.image = VilimaImages::get(VilimaImages::TRIANGLE_RIGHT)
		addButton.toolTipText = "Add Selected Column"
		addButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					handleAddColumns(inactiveViewer.selectedColumnExtension)
				}
			})

		val removeButton = new Button(moveComposite, SWT::PUSH)
		removeButton.layoutData = newGridData
		removeButton.image = VilimaImages::get(VilimaImages::TRIANGLE_LEFT)
		removeButton.toolTipText = "Remove Selected Column"
		removeButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					handleRemoveColumns(activeViewer.selectedVilimaColumns)
				}
			})

		// change order of active columns
		val orderComposite = new Composite(composite, SWT::NONE)
		orderComposite.layoutData = newGridData
		orderComposite.layout = newGridLayoutSwt

		val upButton = new Button(orderComposite, SWT::PUSH)
		upButton.layoutData = newGridData
		upButton.image = VilimaImages::get(VilimaImages::TRIANGLE_UP)
		upButton.toolTipText = "Move Selected Column Up"
		upButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					handleMoveColumns(activeViewer.selectedVilimaColumns, true)
				}
			})

		val downButton = new Button(orderComposite, SWT::PUSH)
		downButton.layoutData = newGridData
		downButton.image = VilimaImages::get(VilimaImages::TRIANGLE_DOWN)
		downButton.toolTipText = "Move Selected Column Down"
		downButton.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					handleMoveColumns(activeViewer.selectedVilimaColumns, false)
				}
			})
	}

	def private void handleAddColumns(Collection<MkFileColumnExtension> extensions) {
		val before = configuration.columns.size

		for (e : extensions) {
			val column = VilimaFactory::eINSTANCE.createVilimaColumn
			column.id = e.id
			column.width = e.width
			configuration.columns += column
		}

		if(configuration.columns.size != before) {
			activeViewer.refresh
		}
	}

	def private void handleRemoveColumns(Collection<VilimaColumn> elements) {
		val before = configuration.columns.size

		configuration.columns -= elements

		if(configuration.columns.size != before) {
			activeViewer.refresh
		}
	}

	def private void handleMoveColumns(Collection<VilimaColumn> elements, boolean up) {
		var changed = false

		for (element : elements) {
			val index = configuration.columns.indexOf(element) + (if(up) -1 else 1)
			configuration.columns.move(index, element as VilimaColumn)
			changed = true
		}

		if(changed) {
			activeViewer.refresh
		}
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

	/* ************************************************************ */
	def private static Collection<MkFileColumnExtension> getSelectedColumnExtension(TreeViewer viewer) {
		viewer.selection.selectedColumnExtension
	}

	def private static Collection<MkFileColumnExtension> getSelectedColumnExtension(ISelection selection) {
		(selection as IStructuredSelection).iterator.filter(MkFileColumnExtension).toList
	}

	def private static Collection<VilimaColumn> getSelectedVilimaColumns(TreeViewer viewer) {
		viewer.selection.selectedVilimaColumns
	}

	def private static Collection<VilimaColumn> getSelectedVilimaColumns(ISelection selection) {
		(selection as IStructuredSelection).iterator.filter(VilimaColumn).toList
	}
}
