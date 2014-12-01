package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.XVilimaLibrary
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.columns.EditableColumnProvider
import com.aljoschability.vilima.ui.columns.VilimaEditingSupport
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import org.eclipse.swt.widgets.TreeColumn

class TableMoviesPart {
	@Inject IContentManager manager
	@Inject ESelectionService selectionService

	TreeViewer viewer

	@PostConstruct
	def void create(Composite parent) {
		var tree = new Tree(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI))
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		tree.headerVisible = true
		tree.linesVisible = true

		viewer = new TreeViewer(tree)
		viewer.contentProvider = new VilimaContentProvider(manager)
		viewer.addSelectionChangedListener(
			[ e |
				selectionService.selection = viewer.selection
			])

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

	// the file name
	//		createStringColumn("Name", 140, VilimaPackage.Literals.MK_FILE__NAME)
	// the title of the segment
	//createStringColumn("Title", 60, VilimaPackage.Literals.VILIMA_FILE__SEGMENT_TITLE)
	// relevant file contents
	//		createTagsColumn()
	// the file size
	//		createSizeColumn("Size", 63, VilimaPackage.Literals.MK_FILE__SIZE)
	// the segment duration
	//		createDurationColumn("Duration", 66)
	}

	def private void createEmptyColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = false
		column.resizable = false
		column.width = 0

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				return ""
			}
		}
	}

	def private void createIconColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = false
		column.resizable = false
		column.width = 20

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			Image image

			override getImage(Object element) {
				if(image == null) {
					val data = Program::findProgram("mkv").imageData
					image = new Image(viewer.tree.display, data)
				}
				return image
			}

			override getText(Object element) {
				return ""
			}

			override dispose() {
				if(image != null) {
					image.dispose()
				}

				super.dispose()
			}
		}
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) XVilimaLibrary content) {
		if(viewer != null) {
			viewer.input = content
		}
	}
}
