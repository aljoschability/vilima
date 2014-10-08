package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkvFile
import com.aljoschability.vilima.VilimaAttachment
import com.aljoschability.vilima.format.VilimaFormatter
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TableViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn
import org.eclipse.swt.program.Program
import org.eclipse.swt.graphics.Image
import java.util.Map
import org.eclipse.swt.widgets.Display
import javax.annotation.PreDestroy

class AttachmentsPart {
	@Inject Display display

	TableViewer viewer

	MkvFile input

	val Map<String, Image> fileImages

	new() {
		fileImages = newLinkedHashMap
	}

	@PostConstruct
	def postConstruct(Composite parent) {
		val table = new Table(parent, SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION))
		table.headerVisible = true
		table.linesVisible = true

		viewer = new TableViewer(table)
		viewer.contentProvider = new VilimaAttachmentsViewerContentProvider

		createNameColumn()
		createMimeColumn()
		createSizeColumn()
		createDescriptionColumn()

		viewer.input = input
		input = null
	}

	def private void createNameColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "Name"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaAttachment) {
					return String.valueOf(element.name)
				}
				return ""
			}

			override getImage(Object element) {
				if (element instanceof VilimaAttachment) {
					val name = element.name
					if (name != null) {
						val index = name.indexOf(".")
						if (index != -1) {
							val ext = name.substring(index).toLowerCase
							return getFileImage(ext)
						}
					}
				}

				return null
			}
		}
	}

	def private void createSizeColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 80
		column.text = "Size"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaAttachment) {
					return VilimaFormatter::fileSize(element.size)
				}
				return ""
			}
		}
	}

	def private void createMimeColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 120
		column.text = "MIME-Type"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaAttachment) {
					if (element.mimeType != null) {
						return element.mimeType
					}
				}
				return ""
			}
		}
	}

	def private void createDescriptionColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "Description"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaAttachment) {
					if (element.description != null) {
						return element.description
					}
				}
				return ""
			}
		}
	}

	def private Image getFileImage(String ext) {
		var image = fileImages.get(ext)
		if (image == null) {
			val program = Program::findProgram(ext)
			if (program != null) {
				val data = program.imageData
				image = new Image(display, data)
				fileImages.put(ext, image)
			}
		}
		return image
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if (selection != null && selection.size() == 1) {
			val selected = selection.firstElement
			if (selected instanceof MkvFile) {
				input = selected
			}
		}

		if (viewer != null && !viewer.table.disposed) {
			viewer.input = input
		}
	}

	@PreDestroy
	def void dispose() {

		// dispose all images
		for (key : fileImages.keySet) {
			fileImages.get(key).dispose()
		}
	}
}

class VilimaAttachmentsViewerContentProvider extends ArrayContentProvider {
	override getElements(Object element) {
		if (element instanceof MkvFile) {
			return element.attachments
		}

		return super.getElements(element)
	}
}
