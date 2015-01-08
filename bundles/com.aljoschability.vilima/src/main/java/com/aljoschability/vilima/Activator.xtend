package com.aljoschability.vilima

import com.aljoschability.core.runtime.AbstractCoreActivator
import com.aljoschability.vilima.scraper.ScraperRegistry
import com.aljoschability.vilima.scraper.impl.ScraperRegistryImpl
import com.aljoschability.vilima.services.ScraperService
import com.aljoschability.vilima.services.VilimaService
import com.aljoschability.vilima.services.impl.ScraperServiceImpl
import com.aljoschability.vilima.services.impl.VilimaServiceImpl
import org.eclipse.core.runtime.IExtensionRegistry

final class Activator extends AbstractCoreActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	ScraperRegistry scraperRegistry

	override protected initialize() {

		// get extension registry
		val extensionRegistryReference = bundleContext.getServiceReference(typeof(IExtensionRegistry))
		val extensionRegistry = bundleContext.getService(extensionRegistryReference)

		// register scraper service
		val scraperService = new ScraperServiceImpl(extensionRegistry)
		bundleContext.registerService(typeof(ScraperService), scraperService, null)

		// register vilima service
		val vilimaService = new VilimaServiceImpl
		bundleContext.registerService(typeof(VilimaService), vilimaService, null)

		// OLD STUFF
		Activator::INSTANCE = this

		scraperRegistry = new ScraperRegistryImpl

		for (ms : scraperRegistry.getMovieScraperExtensions) {
			//			println(ms)
		}

		for (ss : scraperRegistry.getShowScraperExtensions) {
			//			println(ss)
		}

	}

	override protected dispose() {
		Activator::INSTANCE = null
	}

	def ScraperRegistry getScraperRegistry() {
		return scraperRegistry
	}
}
