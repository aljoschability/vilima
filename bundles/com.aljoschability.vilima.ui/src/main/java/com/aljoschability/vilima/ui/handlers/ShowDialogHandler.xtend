package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.e4.ui.workbench.IWorkbench
import org.eclipse.swt.widgets.Shell

class ShowDialogHandler {
	@Execute
	def execute(IWorkbench workbench, @Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {
		println('''ShowDialogHandler has been called.''')
	}
}
