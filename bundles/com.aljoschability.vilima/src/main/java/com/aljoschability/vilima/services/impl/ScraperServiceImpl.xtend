package com.aljoschability.vilima.services.impl

import com.aljoschability.vilima.services.ScraperService
import org.eclipse.core.runtime.IExtensionRegistry

class ScraperServiceImpl implements ScraperService {
	val IExtensionRegistry registry

	new(IExtensionRegistry registry) {
		this.registry = registry
	}
}
