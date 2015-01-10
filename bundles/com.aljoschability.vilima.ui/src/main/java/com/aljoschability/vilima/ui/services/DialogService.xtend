package com.aljoschability.vilima.ui.services

import org.eclipse.jface.dialogs.IDialogSettings

interface DialogService {
	def IDialogSettings getSettings(Class<?> clazz)
}
