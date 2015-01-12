package com.aljoschability.vilima.services.impl

import com.aljoschability.vilima.Activator
import com.aljoschability.vilima.scraper.MovieScraper
import com.aljoschability.vilima.scraper.MovieScraperExtension
import com.aljoschability.vilima.scraper.ShowScraper
import com.aljoschability.vilima.scraper.ShowScraperExtension
import com.aljoschability.vilima.scraper.impl.MovieScraperExtensionImpl
import com.aljoschability.vilima.scraper.impl.ShowScraperExtensionImpl
import com.aljoschability.vilima.services.ScraperService
import com.aljoschability.vilima.xtend.LogExtension
import java.util.List
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.IExtensionRegistry
import org.osgi.framework.BundleContext

class ScraperServiceImpl implements ScraperService {
	static val ID = "com.aljoschability.vilima.scraper"

	static val ATTR_ID = "id"
	static val ATTR_NAME = "name"
	static val ATTR_DESC = "description"
	static val ATTR_URL = "url"
	static val ATTR_ICON = "icon"
	static val ATTR_CLASS = "class"

	boolean initialized = false

	List<MovieScraperExtension> movieScraperExtensions

	List<ShowScraperExtension> showScraperExtensions

	extension LogExtension = new LogExtension("ScraperServiceImpl", Activator::get)

	val IExtensionRegistry registry

	new(BundleContext context) {
		val reference = context.getServiceReference(typeof(IExtensionRegistry))
		registry = context.getService(reference)

		debug("created service")
	}

	def private void initialize() {
		movieScraperExtensions = newArrayList
		showScraperExtensions = newArrayList

		val ces = registry.getConfigurationElementsFor(ID)

		for (ce : ces) {
			val pid = ce.contributor.name
			val id = ce.getAttribute(ATTR_ID)
			val name = ce.getAttribute(ATTR_NAME)
			val desc = ce.getAttribute(ATTR_DESC)
			val url = ce.getAttribute(ATTR_URL)
			val imagePath = ce.getAttribute(ATTR_ICON)
			val scraper = getScraper(ce)

			if(pid == null || id == null || name == null || scraper == null) {
				Activator::get.warn('''Could not register scraper extension with ID «id»!''')
			} else {
				if(scraper instanceof MovieScraper) {
					val ext = new MovieScraperExtensionImpl(pid, id, name, desc, url, imagePath, scraper)
					movieScraperExtensions += ext
				} else if(scraper instanceof ShowScraper) {
					val ext = new ShowScraperExtensionImpl(pid, id, name, desc, url, imagePath, scraper)
					showScraperExtensions += ext
				}
			}
		}

		initialized = true
	}

	override getMovieScraperExtensions() {
		if(!initialized) {
			initialize()
		}

		return movieScraperExtensions
	}

	override getShowScraperExtensions() {
		if(!initialized) {
			initialize()
		}

		return showScraperExtensions
	}

	def private static Object getScraper(IConfigurationElement ce) {
		try {
			val object = ce.createExecutableExtension(ATTR_CLASS);
			if(object instanceof MovieScraper || object instanceof ShowScraper) {
				return object
			}
		} catch(CoreException e) {
			// just ignore exception
		}
		return null
	}
}
