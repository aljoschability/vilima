package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.swt.widgets.Shell

/* @see issue #8 */
class HelpAboutHandler {
	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		val title = "About Vilima"
		val message = "This should be replaced with a read about dialog. E.g. the one from Eclipse."

		MessageDialog::openInformation(shell, title, message)
	}
}
