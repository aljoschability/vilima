package com.aljoschability.vilima.ui.services.impl

import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.services.ColumnService
import com.aljoschability.vilima.xtend.LogExtension
import org.eclipse.core.runtime.IExtensionRegistry
import org.osgi.framework.BundleContext

class ColumnServiceImpl implements ColumnService {
	extension LogExtension = new LogExtension(typeof(ColumnServiceImpl), Activator::get)

	val IExtensionRegistry registry

	new(BundleContext context) {
		registry = context.extensionRegistry
	}

	private static def IExtensionRegistry getExtensionRegistry(BundleContext context) {
		val reference = context.getServiceReference(typeof(IExtensionRegistry))
		return context.getService(reference)
	}

	override start() {
		debug("The column service has been started.")
	}

	override stop() {
		debug("The column service has been stopped.")
	}
}
