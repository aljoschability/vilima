package com.aljoschability.vilima.scraper.impl

import com.aljoschability.vilima.scraper.MovieScraper
import com.aljoschability.vilima.scraper.MovieScraperExtension
import com.aljoschability.vilima.scraper.ScraperExtension
import com.aljoschability.vilima.scraper.ShowScraper
import com.aljoschability.vilima.scraper.ShowScraperExtension
import org.eclipse.xtend.lib.annotations.Data

@Data abstract class ScraperExtensionImpl implements ScraperExtension {
	String pluginId
	String id
	String name
	String description
	String url
	String imagePath
}

@Data class MovieScraperExtensionImpl extends ScraperExtensionImpl implements MovieScraperExtension {
	MovieScraper scraper
}

@Data class ShowScraperExtensionImpl extends ScraperExtensionImpl implements ShowScraperExtension {
	ShowScraper scraper
}
