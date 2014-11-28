package com.aljoschability.vilima.scraper.omdb

import retrofit.http.GET
import retrofit.client.Response
import retrofit.http.Query
import com.aljoschability.vilima.scraper.omdb.internal.OmdbMovie
import com.aljoschability.vilima.scraper.omdb.internal.OmdbShow

interface OmdbService {

	/**
	 * By ID or Title
	 * 
	 * @param s Movie title to search for.
	 */
	@GET("/?type=movie&tomatoes=true")
	def OmdbMovie getMovie(
		@Query("i") String i
	)
	/**
	 * By ID or Title
	 * 
	 * @param s Movie title to search for.
	 */
	@GET("/?type=series&tomatoes=true")
	def OmdbShow getShow(
		@Query("i") String i
	)

	/**
	 * By Search
	 * 
	 * @param s Movie title to search for.
	 */
	@GET("/?type=movie")
	def Response searchMovie(
		@Query("s") String s,
		@Query("y") Integer y
	)

	/**
	 * By Search
	 * 
	 * @param s Movie title to search for.
	 */
	@GET("/?type=series")
	def Response searchShow(
		@Query("s") String s,
		@Query("y") Integer y
	)
}
