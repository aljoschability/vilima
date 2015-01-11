package com.aljoschability.vilima.ui.services.impl

import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.services.DialogService
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.dialogs.DialogSettings
import org.eclipse.jface.dialogs.IDialogSettings
import org.osgi.framework.BundleContext

class DialogServiceImpl implements DialogService {
	static val FILENAME = "dialog_settings.xml"

	val BundleContext context

	val IDialogSettings settings

	new(BundleContext context) {
		this.context = context

		settings = new DialogSettings("Vilima")
	}

	override getSettings(Class<?> clazz) {
		var result = settings.getSection(clazz.canonicalName)
		if(result == null) {
			result = settings.addNewSection(clazz.canonicalName)
		}

		return result
	}

	override start() {
		debug("The dialog service is starting...")

		// load settings
		val file = settingsFile
		if(file.exists) {
			debug('''Reading settings from "«file»"...''')
			settings.load(file.toString)
		} else {
			debug('''Creating empty dialog settings...''')
		}

		debug("The service has been started.")
	}

	override stop() {
		debug("The service is stopping...")

		// save settings file
		val file = settingsFile
		debug('''Saving dialog settings to "«file»"...''')
		settings.save(file.toString)

		debug("The service has been stopped.")
	}

	private def File getSettingsFile() {
		Platform::getStateLocation(context.bundle).append(FILENAME).toFile
	}

	private static def void debug(String message) { Activator::get.debug('''[Dialog Service] «message»''') }
}
