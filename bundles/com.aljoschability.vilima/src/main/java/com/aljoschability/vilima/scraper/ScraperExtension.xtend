package com.aljoschability.vilima.scraper

import com.aljoschability.vilima.scraper.MovieScraper
import com.aljoschability.vilima.scraper.ShowScraper

interface ScraperExtension {

	/**
	 * The identifier of the declaring plug-in.
	 * 
	 * @return Returns the plug-in identifier.
	 */
	def String getPluginId()

	/**
	 * The name of the provider.
	 * 
	 * @return Returns the name.
	 */
	def String getName()

	/**
	 * An optional description for the provider.
	 * 
	 * @return Returns the description.
	 */
	def String getDescription()

	/**
	 * An optional URL for the provider.
	 * 
	 * @return Returns the URL.
	 */
	def String getUrl()

	/**
	 * The image identifier that can be used to get an image for the provider
	 * from the <code>Activator</code>s image registry.
	 * 
	 * @return Returns the image identifier.
	 */
	def String getImagePath()
}

interface ShowScraperExtension extends ScraperExtension {

	/**
	 * The class to be used to scrape show meta data.
	 * 
	 * @return Returns the show scraper.
	 */
	def ShowScraper getScraper()
}

interface MovieScraperExtension extends ScraperExtension {

	/**
	 * The class to be used to scrape movie meta data.
	 * 
	 * @return Returns the movie scraper.
	 */
	def MovieScraper getScraper()
}
