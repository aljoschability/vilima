package com.aljoschability.vilima.ui.wizards

import com.aljoschability.vilima.ui.extensions.SwtExtension
import com.aljoschability.vilima.ui.services.ImageService
import java.io.File
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import com.aljoschability.vilima.ui.Activator

class ConfigurationWizardExternalsPage extends WizardPage {
	extension SwtExtension = SwtExtension::INSTANCE

	Text textExtract

	Label extractHint

	Text extractText

	ImageService imageService

	new(String name) {
		super(name)

		this.imageService = Activator::get.imageService

		title = "External Applications"

		//description = "Configure the applications that are needed and/or recommended for this application to be useful."
		description = "Configure the external applications."

	// TODO: ???imageDescriptor = null
	}

	override createControl(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
		]

		val group = composite.newGroup [
			layoutData = newGridData(true, false)
			layout = newGridLayoutSwt(4)
			text = "Tools"
		]

		// root directory of mkvtoolnix
		group.newLabel(
			[
				layoutData = newGridDataCentered
				text = "MKVToolNix"
			], SWT::TRAIL)

		group.newText(
			[
				layoutData = newGridData(true, false)
			], SWT::SINGLE, SWT::BORDER)

		group.newButton(
			[
				text = "Find…"
			], SWT::PUSH)

		group.newLabel(
			[
				layoutData = newGridData
				image = ImageService::STATE_INFO.toImage
				toolTipText = "Select the directory of MKVToolNix"
			], SWT::NONE)

		// separator
		group.newLabel(
			[
				layoutData = GridDataFactory::fillDefaults.grab(true, false).span(4, 1).create
			], SWT::SEPARATOR, SWT::HORIZONTAL)

		// mkvpropedit
		group.newLabel(
			[
				layoutData = newGridDataCentered
				text = "mkvpropedit"
			], SWT::TRAIL)

		group.newText(
			[
				layoutData = newGridData(true, false)
			], SWT::LEAD, SWT::BORDER)

		group.newButton(
			[
				text = "Select…"
			], SWT::PUSH)

		group.newLabel(
			[
				layoutData = newGridData
				image = ImageService::STATE_ERROR.toImage
				toolTipText = "none found"
			], SWT::NONE)

		// mkvmerge
		group.newLabel(
			[
				layoutData = newGridDataCentered
				text = "mkvmerge"
			], SWT::TRAIL)

		group.newText(
			[
				layoutData = newGridData(true, false)
			], SWT::LEAD, SWT::BORDER)

		group.newButton(
			[
				text = "Select…"
			], SWT::PUSH)

		group.newLabel(
			[
				layoutData = newGridData
				image = ImageService::STATE_ERROR.toImage
				toolTipText = "none found"
			], SWT::NONE)

		// mkvextract
		group.newLabel(
			[
				layoutData = newGridDataCentered
				text = "mkvextract"
			], SWT::TRAIL)

		extractText = group.newText(
			[
				layoutData = newGridData(true, false)
				addModifyListener(newModifyListener[e|modifyText(e.widget as Text)])
			], SWT::LEAD, SWT::BORDER)

		group.newButton(
			[
				text = "Select…"
				addSelectionListener(newSelectionListener[e|selectMkvExtractExecutable()])
			], SWT::PUSH)

		extractHint = group.newLabel(
			[
				layoutData = newGridData
				image = ImageService::STATE_ERROR.toImage
				toolTipText = "none found"
			], SWT::NONE)

		control = composite
	}

	private def Image toImage(String path) {
		imageService.getImage(shell.display, path)
	}

	def void modifyText(Text text) {
		if(text == extractText) {
			val IRunnableWithProgress runnable = [ m |
				val process = Runtime::getRuntime.exec(text.text)
				val result = process.waitFor
				println('''run process «process»''')
				extractHint.image = ImageService::CONTROL_ADD.toImage
				extractHint.toolTipText = extractText.text
			]
			wizard.container.run(false, false, runnable)
			println('''modified text: «text.text»''')
		}
	}

	def private void selectMkvExtractExecutable() {
		selectExecutable(extractText, "mkvextract")
	}

	def private void selectExecutable(Text text, String description) {
		val file = text.asFile

		val dialog = new FileDialog(shell, SWT::OPEN)
		dialog.text = '''Select «description» Executable'''
		dialog.filterExtensions = #["*.*"]
		dialog.filterNames = #["Application"]
		dialog.fileName = file?.name ?: description
		dialog.filterPath = file?.parent

		// open the dialog
		val result = dialog.open
		if(result != null) {
			text.text = result
		}
	}

	def File asFile(Text text) {
		if(text.active) {
			new File(text.text)
		}
	}
}
