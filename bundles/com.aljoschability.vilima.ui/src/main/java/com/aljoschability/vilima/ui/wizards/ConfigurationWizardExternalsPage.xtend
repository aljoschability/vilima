package com.aljoschability.vilima.ui.wizards

import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.widgets.Composite
import com.aljoschability.vilima.ui.extensions.SwtExtension
import org.eclipse.swt.SWT
import com.aljoschability.vilima.ui.VilimaImages

class ConfigurationWizardExternalsPage extends WizardPage {
	extension SwtExtension = SwtExtension::INSTANCE

	new(String name) {
		super(name)

		title = "External Applications"
		description = "Configure the applications that are needed and/or recommended for this application to be useful."
		imageDescriptor = null // TODO: ???
	}

	override createControl(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
		]

		val group = composite.newGroup [
			layoutData = newGridData(true, false)
			layout = newGridLayoutSwt(4)
			text = "MKVToolNix"
		]

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
				text = "Browse..."
			], SWT::PUSH)

		group.newLabel(
			[
				layoutData = newGridData
				image = VilimaImages::get(VilimaImages::TRIANGLE_UP)
				toolTipText = "Found Version 7.4.4"
			], SWT::NONE)

		// mkvmerge
		group.newLabel(
			[
				layoutData = newGridData(true, false)
				text = "mkvmerge"
			], SWT::LEAD)

		group.newLabel(
			[
				layoutData = newGridDataCentered
				image = VilimaImages::get(VilimaImages::TRIANGLE_UP)
				toolTipText = "Found Version 7.4.4"
			], SWT::NONE)

		// mkvextract
		group.newLabel(
			[
				layoutData = newGridDataCentered
				text = "mkvextract"
			], SWT::LEAD)

		group.newLabel(
			[
				layoutData = newGridData(true, false)
				image = VilimaImages::get(VilimaImages::TRIANGLE_UP)
				toolTipText = "Found Version 7.4.4"
			], SWT::NONE)

		control = composite
	}
}
