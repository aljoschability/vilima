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

class FilesPart {
	@Inject IContentManager manager

	TreeViewer viewer

	@PostConstruct
	def void create(Composite parent) {
		var tree = new Tree(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI))
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		tree.headerVisible = true
		tree.linesVisible = true

		viewer = new TreeViewer(tree)
		viewer.contentProvider = new VilimaContentProvider(manager)

		createEmptyColumn()

		createIconColumn()

		//		createStringColumn("Path", 30, VilimaPackage.Literals.MKV_FILE__FILE_PATH)
		createStringColumn("Name", 140, VilimaPackage.Literals.MKV_FILE__FILE_NAME)

		createSizeColumn("Size", 63, VilimaPackage.Literals.MKV_FILE__FILE_SIZE)

		//		createDateColumn("File Date", 30, VilimaPackage.Literals.MKV_FILE__FILE_DATE)
		//		createDateColumn("Segment Date", 30, VilimaPackage.Literals.MKV_FILE__SEGMENT_DATE)
		createDurationColumn("Duration", 66, VilimaPackage.Literals.MKV_FILE__SEGMENT_DURATION)

		//		createStringColumn("Title", 60, VilimaPackage.Literals.MKV_FILE__SEGMENT_TITLE)
		createStringColumn("UID", 60, VilimaPackage.Literals.MKV_FILE__SEGMENT_UID)

		//		createStringColumn("Next UID", 30, VilimaPackage.Literals.MKV_FILE__SEGMENT_NEXT_UID)
		//		createStringColumn("Prev UID", 30, VilimaPackage.Literals.MKV_FILE__SEGMENT_PREVIOUS_UID)
		createCountColumn("Tracks", 49, VilimaPackage.Literals.MKV_FILE__TRACKS)
		createCountColumn("Attachments", 83, VilimaPackage.Literals.MKV_FILE__ATTACHMENTS)
		createCountColumn("Chapters", 62, VilimaPackage.Literals.MKV_FILE__CHAPTERS)
		createCountColumn("Tags", 40, VilimaPackage.Literals.MKV_FILE__TAGS)

		//		createStringColumn("Muxing App", 60, VilimaPackage.Literals.MKV_FILE__SEGMENT_MUXING_APP)
		createStringColumn("Writing App", 60, VilimaPackage.Literals.MKV_FILE__SEGMENT_WRITING_APP)
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

	new() {
		NF = NumberFormat::getNumberInstance
		NF.maximumFractionDigits = 2
	}

	val SimpleDateFormat DF = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss")
	val NumberFormat NF

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
					val size = element.eGet(feature) as Long

					var i = 1
					var result = size as double
					while (result > 1024) {
						result = result / 1024d
						i++
					}

					val unit = switch (i) {
						case 2: "kB"
						case 3: "MB"
						case 4: "GB"
						default: "Bytes"
					}

					return NF.format(result) + " " + unit
				}
				return ""
			}
		}
	}

	private def createDateColumn(String text, int width, EStructuralFeature feature) {
		val column = new TreeColumn(viewer.tree, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {

			override getText(Object element) {
				if (element instanceof EObject) {
					val timestamp = element.eGet(feature) as Long
					if (timestamp > 0) {
						return DF.format(timestamp)
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
