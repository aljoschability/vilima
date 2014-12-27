package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.e4.ui.workbench.IWorkbench
import org.eclipse.swt.widgets.Shell
import org.eclipse.jface.wizard.WizardDialog
import com.aljoschability.vilima.ui.wizards.ConfigurationWizard

class OpenConfigurationWizardHandler {
	@Execute
	def void execute(IWorkbench workbench, @Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {
		val wizard = new ConfigurationWizard

		new WizardDialog(shell, wizard).open
	}
}
