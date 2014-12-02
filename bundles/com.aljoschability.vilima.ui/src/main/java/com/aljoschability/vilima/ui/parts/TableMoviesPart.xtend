package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.XVilimaLibrary
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.columns.EditableColumnProvider
import com.aljoschability.vilima.ui.columns.VilimaEditingSupport
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import com.aljoschability.vilima.ui.util.ProgramImageLabelProvider
import com.aljoschability.vilima.ui.util.VilimaViewerEditorActivationStrategy
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.ColumnViewerEditor
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.jface.viewers.TreeViewerEditor
import org.eclipse.swt.SWT
import org.eclipse.swt.events.KeyAdapter
import org.eclipse.swt.events.KeyEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.TreeColumn

class TableMoviesPart {
	@Inject IContentManager manager
	@Inject ESelectionService selectionService

	TreeViewer viewer

	@PostConstruct
	def void create(Composite parent) {
		viewer = new TreeViewer(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI))
		viewer.tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		viewer.tree.headerVisible = true
		viewer.tree.linesVisible = true

		viewer.contentProvider = new VilimaContentProvider(manager)
		viewer.addSelectionChangedListener(
			[ e |
				selectionService.selection = viewer.selection
			])

		// customize editing behavior
		val strategy = new VilimaViewerEditorActivationStrategy(viewer)
		val features = ColumnViewerEditor::KEEP_EDITOR_ON_DOUBLE_CLICK.bitwiseOr(ColumnViewerEditor::TABBING_HORIZONTAL).
			bitwiseOr(ColumnViewerEditor::TABBING_VERTICAL)
		TreeViewerEditor.create(viewer, strategy, features)

		// empty column to remove the tree expansion space on first column
		createEmptyColumn()

		// file icon to show
		createIconColumn()

		// all registered columns
		val registry = Activator::get.columnRegistry
		for (ce : registry.columnExtensions) {
			val column = new TreeViewerColumn(viewer, ce.style)

			column.column.moveable = true
			column.column.resizable = true
			column.column.width = 100
			column.column.text = ce.name

			column.labelProvider = new ColumnLabelProvider() {
				override getText(Object element) {
					if(element instanceof MkFile) {
						val text = ce.provider.getText(element)
						if(text != null) {
							return text
						}
					}
					return ""
				}
			}

			if(ce.provider instanceof EditableColumnProvider) {
				column.editingSupport = new VilimaEditingSupport(viewer, ce.provider as EditableColumnProvider)
			}
		}

		viewer.tree.addKeyListener(
			new KeyAdapter {
				override keyPressed(KeyEvent e) {
					val key = e.character
					val code = e.keyCode
					println('''pressed "«key»" («code») while editor active: «viewer.cellEditorActive»''')
				}
			})

		// react on traversal
		viewer.tree.addTraverseListener([e|println(e)])

	// react on editor deactivation
	//		viewer.columnViewerEditor.addEditorActivationListener(
	//			new ColumnViewerEditorActivationListener {
	//				override beforeEditorActivated(ColumnViewerEditorActivationEvent event) {}
	//
	//				override afterEditorActivated(ColumnViewerEditorActivationEvent event) {}
	//
	//				override beforeEditorDeactivated(ColumnViewerEditorDeactivationEvent event) {}
	//
	//				override afterEditorDeactivated(ColumnViewerEditorDeactivationEvent event) {
	//					if(event.source instanceof ViewerCell) {
	//						val currentCell = event.source as ViewerCell
	//						val newCell = currentCell.getNeighbor(ViewerCell::ABOVE, true)
	//
	//						viewer.editElement(newCell.element, newCell.columnIndex)
	//					}
	//				}
	//			})
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
