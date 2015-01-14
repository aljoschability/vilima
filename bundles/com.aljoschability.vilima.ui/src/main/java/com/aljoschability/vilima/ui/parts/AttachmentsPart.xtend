package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.extensions.VilimaFormatter
import com.aljoschability.vilima.ui.xtend.SwtExtension
import com.google.common.io.Files
import java.io.File
import java.nio.file.Paths
import java.util.Collection
import java.util.Map
import javax.annotation.PostConstruct
import javax.annotation.PreDestroy
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TableViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.TableColumn

class AttachmentsTreeContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		if(element instanceof MkFile) {
			return element.attachments
		}

		return super.getElements(element)
	}

	override getChildren(Object element) { newArrayOfSize(0) }

	override getParent(Object element) {}

	override hasChildren(Object element) { false }
}

class AttachmentsPart {
	extension SwtExtension = SwtExtension::INSTANCE

	val Map<String, Image> fileImages = newLinkedHashMap

	TableViewer viewer

	Collection<MkAttachment> input

	@PostConstruct
	def postConstruct(Composite parent) {
		val sash = parent.newSashForm(SWT::HORIZONTAL, [layoutData = newGridData(true, true)])

		sash.createTable()

		sash.createDetails()

		sash.weights = #[4, 1]
	}

	private def void createTable(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		viewer = composite.newTableViewer(
			[
				table.layoutData = newGridData(true, true)
				table.headerVisible = true
				table.linesVisible = true
				contentProvider = ArrayContentProvider::getInstance()
			], SWT::SINGLE, SWT::FULL_SELECTION, SWT::BORDER)

		viewer.addDoubleClickListener(
			[
				val att = (selection as IStructuredSelection).firstElement as MkAttachment
				val mkfile = att.file
				val file = Paths::get(mkfile.path, mkfile.name).toFile
				val aFile = File::createTempFile(att.name, "." + Files::getFileExtension(att.name))
				val id = mkfile.attachments.indexOf(att)
				val command = '''mkvextract attachments "«file»" «id + 1»:"«aFile»"'''
				println(command)
			])

		// columns
		createAttachmentColumn("Name", 160, SWT::LEAD, false, true,
			[ MkAttachment a |
				String.valueOf(a.name)
			])
		createAttachmentColumn("ID", 27, SWT::CENTER, true, false,
			[ MkAttachment a |
				String.valueOf(a.id)
			])
		createAttachmentColumn("UID", 180, SWT::LEAD, true, false,
			[ MkAttachment a |
				String.valueOf(a.uid)
			])
		createAttachmentColumn("Size", 100, SWT::TRAIL, false, false,
			[ MkAttachment a |
				VilimaFormatter::fileSize(a.size)
			])
		createAttachmentColumn("Type", 160, SWT::LEAD, false, false,
			[ MkAttachment a |
				String.valueOf(a.mimeType)
			])
		createAttachmentColumn("Description", 72, SWT::LEAD, false, false,
			[ MkAttachment a |
				String.valueOf(a.description)
			])

		viewer.input = input
		input = null
	}

	private def void createDetails(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		val group = composite.newGroup [
			text = "Details"
			layout = newGridLayoutSwt(3)
			layoutData = newGridData(true, true)
		]
	}

	def private createAttachmentColumn(String title, int width, int style, boolean monospaced, boolean showIcon,
		(MkAttachment)=>String function) {
		val column = new TableColumn(viewer.table, style)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = title

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if(element instanceof MkAttachment) {
					return function.apply(element)
				}
				return ""
			}

			override getImage(Object element) {
				if(showIcon) {
					if(element instanceof MkAttachment) {
						return getFileImage(element)
					}
				}

				return null
			}

			override getFont(Object element) {
				if(monospaced) {
					return JFaceResources::getTextFont
				}
			}
		}
	}

	def private Image getFileImage(MkAttachment element) {
		val name = element.getName
		if(name != null) {
			val index = name.indexOf(".")
			if(index != -1) {
				val ext = name.substring(index).toLowerCase
				var image = fileImages.get(ext)
				if(image == null) {
					val program = Program::findProgram(ext)
					if(program != null) {
						val data = program.imageData
						image = new Image(viewer.control.display, data)
						fileImages.put(ext, image)
					}
				}
				return image
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if(selection != null && selection.size == 1) {
			val element = selection.firstElement
			if(element instanceof MkFile) {
				input = element.attachments
			}
		}

		if(viewer.active) {
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
