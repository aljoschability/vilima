package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.MApplication
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.e4.ui.workbench.IWorkbench
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.swt.widgets.Shell

class ExitHandler {
	@CanExecute
	def boolean canExecute(MApplication application, Shell shell) {

		// register close handler
		//		var IWindowCloseHandler handler = [ w |
		//			return MessageDialog::openConfirm(shell, "Close", "You will loose data. Really close?")
		//		]
		//		application.getContext().set(IWindowCloseHandler, handler);
		return true
	}

	@Execute
	def execute(IWorkbench workbench, @Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {
		if (MessageDialog.openConfirm(shell, "Confirmation", "Do you want to exit?")) {
			workbench.close
		}
	}
}
