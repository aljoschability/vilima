package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.ui.dialogs.RenameFilesDialog
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.swt.widgets.Shell

class RenameFilesHandler {
	@Execute
	def execute(@Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {
		new RenameFilesDialog(shell).open

		return true
	}
}
