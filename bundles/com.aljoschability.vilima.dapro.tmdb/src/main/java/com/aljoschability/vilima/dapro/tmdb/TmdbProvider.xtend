package com.aljoschability.vilima.dapro.tmdb

import java.util.List

class TmdbProvider {
}

interface IMovieDataProvider {
	def List<IMovieResult> searchTitle(String title)

	def IMovieResult get(String id, String value)
}

interface IMovieResult {
	def String getTitle()

	def String getSubtitle()

	def List<String> getGenres()

	def String getDateReleased()

	def String getId(String type) // imdb,tmdb,tvdb,trakt

	def String getSummary()

	def String getPosterUrl()
}
