package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.extensions.VilimaFormatter
import com.google.common.io.Files
import java.io.File
import java.nio.file.Paths
import java.util.Map
import javax.annotation.PostConstruct
import javax.annotation.PreDestroy
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
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn

class AttachmentsPart {
	@Inject Display display

	TableViewer viewer

	MkFile input

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
		viewer.addDoubleClickListener(
			[
				val att = (selection as IStructuredSelection).firstElement as MkAttachment
				val mkfile = att.eContainer as MkFile
				val file = Paths::get(mkfile.path, mkfile.name).toFile
				val aFile = File::createTempFile(att.name, "." + Files::getFileExtension(att.name))
				val id = mkfile.attachments.indexOf(att)
				val command = '''mkvextract attachments "«file»" «id + 1»:"«aFile»"'''
				println(command)
			])

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
				if(element instanceof MkAttachment) {
					return String.valueOf(element.getName)
				}
				return ""
			}

			override getImage(Object element) {
				if(element instanceof MkAttachment) {
					val name = element.getName
					if(name != null) {
						val index = name.indexOf(".")
						if(index != -1) {
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
				if(element instanceof MkAttachment) {
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
				if(element instanceof MkAttachment) {
					if(element.getMimeType != null) {
						return element.getMimeType
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
				if(element instanceof MkAttachment) {
					if(element.getDescription != null) {
						return element.getDescription
					}
				}
				return ""
			}
		}
	}

	def private Image getFileImage(String ext) {
		var image = fileImages.get(ext)
		if(image == null) {
			val program = Program::findProgram(ext)
			if(program != null) {
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

		if(selection != null && selection.size() == 1) {
			val selected = selection.firstElement
			if(selected instanceof MkFile) {
				input = selected
			}
		}

		if(viewer != null && !viewer.table.disposed) {
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
		if(element instanceof MkFile) {
			return element.attachments
		}

		return super.getElements(element)
	}
}
