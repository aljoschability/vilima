package com.aljoschability.vilima.services.impl

import com.aljoschability.vilima.services.ScraperService
import org.eclipse.core.runtime.IExtensionRegistry
import org.osgi.framework.BundleContext

class ScraperServiceImpl implements ScraperService {
	val IExtensionRegistry registry

	new(BundleContext context) {
		val reference = context.getServiceReference(typeof(IExtensionRegistry))
		registry = context.getService(reference)
	}
}
