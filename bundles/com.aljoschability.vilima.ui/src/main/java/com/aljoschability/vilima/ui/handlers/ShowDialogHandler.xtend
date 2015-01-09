package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.swt.widgets.Shell

class ShowDialogHandler {
	@Execute
	def execute(@Named(IServiceConstants.ACTIVE_SHELL) Shell shell,
		@Named(IServiceConstants.ACTIVE_SELECTION) Object selected) {
		println('''ShowDialogHandler has been called for «selected».''')
	}
}
