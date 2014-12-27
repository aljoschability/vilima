package com.aljoschability.vilima.ui.wizards

import com.aljoschability.vilima.ui.Activator
import org.eclipse.jface.wizard.Wizard

class ConfigurationWizard extends Wizard {
	new() {
		helpAvailable = false
		needsProgressMonitor = false
		defaultPageImageDescriptor = null // TODO: choose image
		windowTitle = "Basic Configuration"

		// dialog settings
		val bundleSettings = Activator::get.dialogSettings
		dialogSettings = bundleSettings.getSection(ConfigurationWizard.canonicalName)
		if(dialogSettings == null) {

			// TODO: new settings
			dialogSettings = bundleSettings.addNewSection(ConfigurationWizard.canonicalName)
		}
	}

	override performFinish() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override addPages() {
		addPage(new ConfigurationWizardExternalsPage("externals"))
	}
}
