package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaLibrary
import com.aljoschability.vilima.VilimaPackage
import com.aljoschability.vilima.format.VilimaFormatter
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
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

		// the file name
		createStringColumn("Name", 140, VilimaPackage.Literals.MK_FILE__NAME)

		// the title of the segment
		//createStringColumn("Title", 60, VilimaPackage.Literals.VILIMA_FILE__SEGMENT_TITLE)
		// relevant file contents
		createTagsColumn()

		// the file size
		createSizeColumn("Size", 63, VilimaPackage.Literals.MK_FILE__SIZE)

		// the segment duration
		createDurationColumn("Duration", 66)

	}

	def private void createTagsColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 40
		column.text = "Tags"

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					val value = element.tags.size
					if (value > 0) {
						return String.valueOf(value)
					}
				}
				return ""
			}
		}
	}

	def private void createStringColumn(String text, int width, EStructuralFeature feature) {
		val column = new TreeColumn(viewer.tree, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof EObject) {
					val value = element.eGet(feature)
					if (value != null) {
						return String.valueOf(value)
					}
				}
				return ""
			}
		}
	}

	def private void createDurationColumn(String text, int width) {
		val column = new TreeColumn(viewer.tree, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {

			override getText(Object element) {
				if (element instanceof MkFile) {
					if (element.getInformation != null) {
						return VilimaFormatter::getTime(element.getInformation.getDuration)
					}
				}
				return ""
			}
		}
	}

	def private void createSizeColumn(String text, int width, EStructuralFeature feature) {
		val column = new TreeColumn(viewer.tree, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof EObject) {
					val size = element.eGet(feature)
					if (size instanceof Long) {
						return VilimaFormatter::fileSize(size)
					}
				}
				return ""
			}
		}
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
				if (image == null) {
					val data = Program::findProgram("mkv").imageData
					image = new Image(viewer.tree.display, data)
				}
				return image
			}

			override getText(Object element) {
				return ""
			}

			override dispose() {
				if (image != null) {
					image.dispose()
				}

				super.dispose()
			}
		}
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) VilimaLibrary content) {
		if (viewer != null) {
			viewer.input = content
		}
	}
}
