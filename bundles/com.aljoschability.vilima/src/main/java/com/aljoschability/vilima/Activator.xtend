package com.aljoschability.vilima

import com.aljoschability.vilima.runtime.AbstractLoggingBundleActivator
import com.aljoschability.vilima.services.ScraperService
import com.aljoschability.vilima.services.VilimaService
import com.aljoschability.vilima.services.impl.ScraperServiceImpl
import com.aljoschability.vilima.services.impl.VilimaServiceImpl

final class Activator extends AbstractLoggingBundleActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {

		// register vilima service
		bundleContext.registerService(typeof(VilimaService), new VilimaServiceImpl(bundleContext), null)
		debug("The vilima service has been registered.")

		// register scraper service
		bundleContext.registerService(typeof(ScraperService), new ScraperServiceImpl(bundleContext), null)
		debug("The scraper service has been registered.")

		Activator::INSTANCE = this
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
