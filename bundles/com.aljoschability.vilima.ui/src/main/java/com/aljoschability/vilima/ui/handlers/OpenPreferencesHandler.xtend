package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.swt.widgets.Shell

class OpenPreferencesHandler {
	@Execute
	def void execute(@Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {

		//val dialog = new PreferenceDialog(shell, new PreferenceManager)
		//dialog.open()
		println('''preference dialog not implemented''')
	}
}
