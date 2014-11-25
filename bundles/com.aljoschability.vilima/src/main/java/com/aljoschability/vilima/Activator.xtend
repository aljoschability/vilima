package com.aljoschability.vilima

import com.aljoschability.core.runtime.AbstractCoreActivator
import com.aljoschability.vilima.scraper.ScraperRegistry
import com.aljoschability.vilima.scraper.impl.ScraperRegistryImpl

final class Activator extends AbstractCoreActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	ScraperRegistry scraperRegistry

	override protected initialize() {
		Activator::INSTANCE = this

		scraperRegistry = new ScraperRegistryImpl

		for (ms : scraperRegistry.getMovieScraperExtensions) {
			println(ms)
		}

		for (ss : scraperRegistry.getShowScraperExtensions) {
			println(ss)
		}
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}

	def ScraperRegistry getScraperRegistry() {
		return scraperRegistry
	}
}
