package com.aljoschability.vilima.ui.services.impl

import org.osgi.framework.BundleContext
import com.aljoschability.vilima.ui.services.DialogService
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.dialogs.DialogSettings

class DialogServiceImpl implements DialogService {
	val IDialogSettings settings

	new(BundleContext context) {
		settings = new DialogSettings(typeof(DialogService).canonicalName)
	}

	override getSettings(Class<?> clazz) {
		var result = settings.getSection(clazz.canonicalName)
		if(result == null) {
			result = settings.addNewSection(clazz.canonicalName)
		}

		return result
	}
}
