package com.aljoschability.vilima.ui.wizards

import com.aljoschability.vilima.ui.services.DialogService
import org.eclipse.e4.core.contexts.IEclipseContext
import org.eclipse.jface.wizard.Wizard

class ConfigurationWizard extends Wizard {
	new(IEclipseContext context) {

		// configuration
		// TODO: choose image defaultPageImageDescriptor = null
		helpAvailable = false
		needsProgressMonitor = false
		windowTitle = "Basic Configuration"

		// dialog settings
		dialogSettings = context.get(DialogService).getSettings(ConfigurationWizard)
	}

	override performFinish() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override addPages() {
		addPage(new ConfigurationWizardExternalsPage("externals"))
	}
}
