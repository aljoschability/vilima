package com.aljoschability.vilima.ui.services.impl

import com.aljoschability.vilima.ui.services.ColumnService
import org.eclipse.core.runtime.IExtensionRegistry
import org.osgi.framework.BundleContext
import com.aljoschability.vilima.ui.Activator

class ColumnServiceImpl implements ColumnService {
	val IExtensionRegistry registry

	new(BundleContext context) {
		registry = context.extensionRegistry
	}

	private static def IExtensionRegistry getExtensionRegistry(BundleContext context) {
		val reference = context.getServiceReference(typeof(IExtensionRegistry))
		return context.getService(reference)
	}

	override start() {
		Activator::get.debug("The column service has been started.")
	}

	override stop() {
		Activator::get.debug("The column service has been stopped.")
	}
}
