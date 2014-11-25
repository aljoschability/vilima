package com.aljoschability.vilima.scraper

import java.util.List

interface ScraperRegistry {
	def List<MovieScraperExtension> getMovieScraperExtensions()

	def List<ShowScraperExtension> getShowScraperExtensions()
}
