package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.e4.ui.workbench.IWorkbench
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.swt.widgets.Shell

/* @see issue #7 */
class FileExitHandler {
	@Execute
	def execute(IWorkbench workbench, @Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		if(MessageDialog.openConfirm(shell, "Exit Application", "Do you want to exit the application?")) {
			workbench.close
		}
	}
}
