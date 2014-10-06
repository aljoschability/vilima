package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.MkvFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaPackage
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import java.text.NumberFormat
import java.text.SimpleDateFormat
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
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
import java.util.List
import com.aljoschability.vilima.VilimaContent
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import com.aljoschability.vilima.format.VilimaFormatter

class FilesPart {
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
		createStringColumn("Name", 140, VilimaPackage.Literals.MKV_FILE__FILE_NAME)

		// the title of the segment
		createStringColumn("Title", 60, VilimaPackage.Literals.MKV_FILE__SEGMENT_TITLE)

		// relevant file contents
		createCountColumn("Tracks", 49, VilimaPackage.Literals.MKV_FILE__TRACKS)
		createAttachmentColumn()
		createChaptersColumn()
		createTagsColumn()

		// the file size
		createSizeColumn("Size", 63, VilimaPackage.Literals.MKV_FILE__FILE_SIZE)

		// the segment duration
		createDurationColumn("Duration", 66, VilimaPackage.Literals.MKV_FILE__SEGMENT_DURATION)

	}

	def createTagsColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 40
		column.text = "Tags"

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkvFile) {
					val value = element.tags.size
					if (value > 0) {
						return String.valueOf(value)
					}
				}
				return ""
			}
		}
	}

	def createAttachmentColumn() {
		val column = new TreeColumn(viewer.tree, SWT::LEAD)
		column.moveable = true
		column.resizable = true
		column.width = 83
		column.text = "Attachments"

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkvFile) {
					val b = new StringBuilder

					for (att : element.attachments) {
						b.append(att.name)
						b.append(" (")
						b.append(att.size)
						b.append("bytes)")
						b.append(", ")
					}

					if (b.length != 0) {
						return b.toString.substring(0, b.length - 2)
					}
				}
				return ""
			}
		}
	}

	def createChaptersColumn() {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)
		column.moveable = true
		column.resizable = true
		column.width = 62
		column.text = "Chapters"

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkvFile) {
					var count = 0
					for (edition : element.editions) {
						for (chapter : edition.entries) {
							count++
						}
					}
					if (count > 0) {
						return String.valueOf(count)
					}
				}
				return ""
			}
		}
	}

	private def createCountColumn(String text, int width, EStructuralFeature feature) {
		val column = new TreeColumn(viewer.tree, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof EObject) {
					val value = element.eGet(feature)
					if (value instanceof List<?>) {
						return String.valueOf(value.size)
					}
				}
				return ""
			}
		}
	}

	private def createStringColumn(String text, int width, EStructuralFeature feature) {
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

	private def createDurationColumn(String text, int width, EStructuralFeature feature) {
		val column = new TreeColumn(viewer.tree, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {

			override getText(Object element) {
				if (element instanceof EObject) {
					val duration = element.eGet(feature) as Long

					if (duration > 0) {
						val ms = duration % 1000
						val seconds = (duration / 1000) % 60;
						val minutes = ((duration / (1000 * 60)) % 60);
						val hours = ((duration / (1000 * 60 * 60)) % 24);

						val format = "%d:%02d:%02d,%03d"

						return String.format(format, hours, minutes, seconds, ms)
					}
				}
				return ""
			}
		}
	}

	private def createSizeColumn(String text, int width, EStructuralFeature feature) {
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

	private def void createEmptyColumn() {
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

	private def void createIconColumn() {
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
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) VilimaContent content) {
		println('''handleRefresh(«content»)''')
		if (viewer != null) {
			viewer.input = content
		}
	}
}
