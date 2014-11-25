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
}

interface MovieCandidate2 {

	def Map<String, String> getIdentifiers()

	def String getTitle()

	def String getTagline()

	def String getReleaseDate()

	def String getSummary()

	def List<String> getGenres()

	def String getNetwork()

	def Integer getRuntime()

	def Float getRatingPercentage()

	def Integer getRatingCount()

	def String getPosterUrl()
}
