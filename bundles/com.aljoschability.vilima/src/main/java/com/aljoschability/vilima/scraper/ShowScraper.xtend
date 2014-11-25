package com.aljoschability.vilima.scraper

import java.util.List

interface ShowScraper {
	def List<ShowCandidate> findShow(String title)

	def Show getShow(String identifier)
}

interface Show {
}
