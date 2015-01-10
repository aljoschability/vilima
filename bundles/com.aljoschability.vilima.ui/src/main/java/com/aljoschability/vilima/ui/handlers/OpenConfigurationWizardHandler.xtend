package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.ui.wizards.ConfigurationWizard
import org.eclipse.e4.core.contexts.IEclipseContext
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.swt.widgets.Shell

class OpenConfigurationWizardHandler {
	@Execute
	def void execute(IEclipseContext context) {
		val shell = context.get(Shell)
		val wizard = new ConfigurationWizard(context)

		new WizardDialog(shell, wizard).open()
	}
}
