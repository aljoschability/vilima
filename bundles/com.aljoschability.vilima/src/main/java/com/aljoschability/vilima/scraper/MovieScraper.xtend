package com.aljoschability.vilima.scraper

import java.util.List
import com.aljoschability.vilima.ScrapeMovie

interface MovieScraper {
	def List<ScrapeMovie> findMovie(String title)

	def Movie getMovie(String identifier)
}

interface Movie {
}
