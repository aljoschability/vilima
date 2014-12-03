package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.VilimaColumnConfiguration
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.XVilimaLibrary
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.columns.ColumnExtension
import com.aljoschability.vilima.ui.columns.EditableColumnProvider
import com.aljoschability.vilima.ui.columns.VilimaEditingSupport
import com.aljoschability.vilima.ui.dialogs.ColumnConfigurationDialog
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import com.aljoschability.vilima.ui.util.ProgramImageLabelProvider
import com.aljoschability.vilima.ui.util.VilimaViewerEditorActivationStrategy
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.PersistState
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.ColumnViewerEditor
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.jface.viewers.TreeViewerEditor
import org.eclipse.jface.window.Window
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.graphics.Point
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Menu
import org.eclipse.swt.widgets.MenuItem
import org.eclipse.swt.widgets.TreeColumn

class TableMoviesPart {
	static val SETTINGS_COLUMN_IDS = "COLUMN_IDS"
	static val SETTINGS_COLUMN_WIDTHS = "COLUMN_WIDTHS"
	static val SETTINGS_SORT_ID = "SORT_ID"

	@Inject IContentManager manager
	@Inject ESelectionService selectionService
	IDialogSettings settings

	TreeViewer viewer

	new() {
		initializeDialogSettings()
	}

	def private void initializeDialogSettings() {
		val bundleSettings = Activator::get.dialogSettings
		settings = bundleSettings.getSection(TableMoviesPart.name)
		if(settings == null) {
			settings = bundleSettings.addNewSection(TableMoviesPart.name)

			settings.put(SETTINGS_COLUMN_IDS, #["file.name", "segment.title", "segment.duration"])
			settings.put(SETTINGS_COLUMN_WIDTHS, #["240", "160", "61"])
			settings.put(SETTINGS_SORT_ID, "file.name")
		}
	}

	@PersistState
	def void persistState() {

		// store current layout
		val configuration = readColumnConfiguration()
		val count = configuration.columns.size

		val String[] ids = newArrayOfSize(count)
		val String[] widths = newArrayOfSize(count)

		for (var i = 0; i < count; i++) {
			val column = configuration.columns.get(i)
			ids.set(i, column.id)
			widths.set(i, String.valueOf(column.width))
		}

		settings.put(SETTINGS_COLUMN_IDS, ids)
		settings.put(SETTINGS_COLUMN_WIDTHS, widths)
		settings.put(SETTINGS_SORT_ID, configuration.sortColumnId)
	}

	@PostConstruct
	def void create(Composite parent) {
		viewer = new TreeViewer(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI).bitwiseOr(SWT::BORDER))
		viewer.tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		viewer.tree.headerVisible = true
		viewer.tree.linesVisible = true

		viewer.contentProvider = new VilimaContentProvider(manager)
		viewer.addSelectionChangedListener(
			[ e |
				selectionService.selection = viewer.selection
			])

		// configuration menu
		val headerMenu = new Menu(viewer.tree)

		// configure columns menu item
		val configureItem = new MenuItem(headerMenu, SWT::PUSH)
		configureItem.text = "Configure Columns"
		configureItem.addSelectionListener(
			new SelectionAdapter {
				override widgetSelected(SelectionEvent e) {
					val configuration = readColumnConfiguration()
					val dialog = new ColumnConfigurationDialog(viewer.tree.shell, configuration)
					if(dialog.open == Window::OK) {
						handleColumnsChanged(configuration)
						viewer.refresh
					}
				}
			})

		// listen to menu detection
		viewer.tree.addMenuDetectListener(
			[ e |
				val pt = viewer.tree.display.map(null, viewer.tree, new Point(e.x, e.y))
				val clientArea = viewer.tree.clientArea
				// decide which menu to set
				if(clientArea.y <= pt.y && pt.y < (clientArea.y + viewer.tree.headerHeight)) {
					viewer.tree.menu = headerMenu
				} else {
					viewer.tree.menu = null
				}
			])

		// dispose the menus manually
		viewer.tree.addDisposeListener(
			[
				if(headerMenu != null && !headerMenu.disposed) {
					headerMenu.dispose
				}
			])

		// customize editing behavior
		val strategy = new VilimaViewerEditorActivationStrategy(viewer)
		val features = ColumnViewerEditor::KEEP_EDITOR_ON_DOUBLE_CLICK.bitwiseOr(ColumnViewerEditor::TABBING_HORIZONTAL)
		TreeViewerEditor.create(viewer, strategy, features)

		// empty column to remove the tree expansion space on first column
		createEmptyColumn()

		// file icon to show
		createIconColumn()

		// configured columns
		handleColumnsChanged(createConfigurationFromDialogSettings())
	}

	def private VilimaColumnConfiguration createConfigurationFromDialogSettings() {
		val configuration = VilimaFactory::eINSTANCE.createVilimaColumnConfiguration

		configuration.sortColumnId = settings.get(SETTINGS_SORT_ID)

		val ids = settings.getArray(SETTINGS_COLUMN_IDS)
		val widths = settings.getArray(SETTINGS_COLUMN_WIDTHS)
		for (var i = 0; i < ids.length; i++) {
			val column = VilimaFactory::eINSTANCE.createVilimaColumn

			column.id = ids.get(i)
			column.width = Integer.parseInt(widths.get(i))

			configuration.columns += column
		}

		return configuration
	}

	def private VilimaColumnConfiguration readColumnConfiguration() {
		val configuration = VilimaFactory::eINSTANCE.createVilimaColumnConfiguration
		for (treeColumnIndex : viewer.tree.columnOrder) {
			val treeColumn = viewer.tree.columns.get(treeColumnIndex)

			val column = VilimaFactory::eINSTANCE.createVilimaColumn
			column.id = (treeColumn.data as ColumnExtension).id
			column.width = treeColumn.width

			configuration.columns += column
		}
		return configuration
	}

	def private void handleColumnsChanged(VilimaColumnConfiguration configuration) {
		viewer.tree.redraw = false

		// remove columns
		for (col : viewer.tree.columns) {
			col.dispose
		}

		// add columns
		for (col : configuration.columns) {
			val ce = Activator::get.columnRegistry.columns.get(col.id)

			val column = new TreeViewerColumn(viewer, ce.alignment)

			column.column.moveable = true
			column.column.resizable = true
			column.column.width = col.width
			column.column.text = ce.name
			column.column.data = ce

			column.labelProvider = ce.provider.labelProvider

			if(ce.provider instanceof EditableColumnProvider) {
				column.editingSupport = new VilimaEditingSupport(viewer, ce.provider as EditableColumnProvider)
			}
		}

		viewer.tree.redraw = true
	}

	def private void createEmptyColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = false
		column.resizable = false
		column.width = 0

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) { "" }
		}
	}

	def private void createIconColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = false
		column.resizable = false
		column.width = 20

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ProgramImageLabelProvider(column.display)
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) XVilimaLibrary content) {
		if(viewer != null) {
			viewer.input = content
		}
	}
}
