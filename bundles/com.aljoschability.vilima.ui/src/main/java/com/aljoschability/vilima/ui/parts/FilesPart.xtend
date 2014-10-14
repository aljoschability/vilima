package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaLibrary
import com.aljoschability.vilima.format.VilimaFormatter
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TableViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn

class FilesPart {
	@Inject Display display
	@Inject ESelectionService selectionService

	TableViewer viewer

	Object input

	@PostConstruct
	def void create(Composite parent) {
		var table = new Table(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI))
		table.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		table.headerVisible = true
		table.linesVisible = true

		viewer = new TableViewer(table)
		viewer.contentProvider = ArrayContentProvider::getInstance
		viewer.addSelectionChangedListener(
			[ e |
				selectionService.selection = viewer.selection
			])

		// the file name
		createFileNameColumn()

		// the title of the segment
		createSegmentTitleColumn()

		// relevant file contents
		createTagsColumn()

		// the file size
		createSizeColumn()

		// the segment duration
		createDurationColumn()

		viewer.input = input
	}

	def createFileNameColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "File Name"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			Image image

			override getText(Object element) {
				if (element instanceof MkFile) {
					return String.valueOf(element.getName)
				}
				return ""
			}

			override getImage(Object element) {
				if (image == null) {
					val data = Program::findProgram("mkv").imageData
					image = new Image(display, data)
				}
				return image
			}

			override dispose() {
				if (image != null) {
					image.dispose()
				}

				super.dispose()
			}
		}
	}

	def private void createSegmentTitleColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 120
		column.text = "Segment Title"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					if (element.getInfo != null) {
						val value = element.getInfo.getTitle
						if (value != null) {
							return value
						}
					}
				}
				return ""
			}
		}
	}

	def private void createTagsColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 40
		column.text = "Tags"

		val viewerColumn = new TableViewerColumn(viewer, column)
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

	def private void createSizeColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 73
		column.text = "Size"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return VilimaFormatter::fileSize(element.getSize)
				}
				return ""
			}
		}
	}

	def private void createDurationColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 73
		column.text = "Duration"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					if (element.getInfo != null) {
						return VilimaFormatter::getTime(element.getInfo.getDuration)
					}
				}
				return ""
			}
		}
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) VilimaLibrary content) {
		input = content.files

		if (viewer != null && !viewer.control.disposed) {
			viewer.input = input
		}
	}
}
