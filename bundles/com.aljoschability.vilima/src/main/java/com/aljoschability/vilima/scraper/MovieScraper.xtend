package com.aljoschability.vilima.scraper

import java.util.List

interface MovieScraper {
	def List<MovieCandidate> findMovie(String title)

	def Movie getMovie(String identifier)
}

interface Movie {
}
