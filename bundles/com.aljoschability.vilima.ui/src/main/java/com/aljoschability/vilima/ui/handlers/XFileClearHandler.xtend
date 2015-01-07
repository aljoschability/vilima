package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.VilimaManager
import javax.inject.Named
import javax.inject.Provider
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.ui.basic.MPart
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.dialogs.MessageDialogWithToggle
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Shell
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.jface.dialogs.IDialogConstants

class XFileClearHandler {

	@CanExecute
	def boolean canExecute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		val object = part.object

		if(object instanceof Provider<?>) {
			val manager = object.get
			if(manager instanceof VilimaManager) {
				return !manager.resourceSet.resources.empty
			}
		}
		return false
	}

	def private newQuestionDialog(Shell shell, String title, String message, String[] labels, int defaultIndex) {
		val dialog = new MessageDialogWithToggle(shell, title, null, message, MessageDialog::QUESTION, labels,
			defaultIndex, null, false)

		dialog.prefStore = null // TODO: get store
		dialog.prefKey = null // TODO: decide on key

		return dialog
	}

	def private MessageDialogWithToggle newDialog(Shell shell) {
		val title = "Unsaved Changes"
		val message = "Some of the files have been modified. Do you want to save them?"
		val labels = #["Save Changes", "Discard Changes", "Cancel"]

		newQuestionDialog(shell, title, message, labels, 0)
	}

	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_PART) MPart part,
		@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		val manager = (part.object as Provider<?>).get as VilimaManager

		val result = newDialog(shell).open

		switch result {
			case MessageDialog::CANCEL: println("do nothing")
			case IDialogConstants::INTERNAL_ID: println("save files")
			case IDialogConstants::INTERNAL_ID + 1: println("discard changes")
		}
		println(result)

		for (resource : manager.resourceSet.resources) {
			resource.unload
		}
		manager.resourceSet.resources.clear
	}
}
