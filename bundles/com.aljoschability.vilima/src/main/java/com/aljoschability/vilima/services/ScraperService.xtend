package com.aljoschability.vilima.services

import com.aljoschability.vilima.scraper.MovieScraperExtension
import com.aljoschability.vilima.scraper.ShowScraperExtension
import java.util.List

interface ScraperService {
	def List<MovieScraperExtension> getMovieScraperExtensions()

	def List<ShowScraperExtension> getShowScraperExtensions()
}
