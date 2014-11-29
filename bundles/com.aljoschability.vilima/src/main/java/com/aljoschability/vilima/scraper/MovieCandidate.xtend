package com.aljoschability.vilima.scraper

import java.util.List
import java.util.Map

interface MovieCandidate {
	def Map<String, String> getIdentifiers()

	def String getTitle()

	def String getSummary()

	def List<String> getGenres()

	def String getReleaseDate()

	def Double getRating()

	def String getInfoUrl()

	def String getPosterUrl()

	def String getTagline()

	def String getNetwork()

	def Integer getRuntime()

	def Float getRatingPercentage()

	def Integer getRatingCount()
}
