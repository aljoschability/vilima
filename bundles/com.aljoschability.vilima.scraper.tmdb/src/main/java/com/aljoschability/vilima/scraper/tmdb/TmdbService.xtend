package com.aljoschability.vilima.scraper.tmdb

import com.aljoschability.vilima.scraper.tmdb.internal.SearchResultMovie
import com.aljoschability.vilima.scraper.tmdb.internal.SearchResultShow
import com.aljoschability.vilima.scraper.tmdb.internal.TmdbMovie
import com.aljoschability.vilima.scraper.tmdb.internal.TmdbShow
import com.aljoschability.vilima.scraper.tmdb.internal.TmdbShowSeason
import retrofit.http.GET
import retrofit.http.Path
import retrofit.http.Query
import com.aljoschability.vilima.scraper.tmdb.internal.TmdbConfiguration
import com.aljoschability.vilima.scraper.tmdb.internal.TmdbMovieCollection

interface TmdbService {

	/**
	 * Get the system wide configuration information. Some elements of the API require some
	 * knowledge of this configuration data. The purpose of this is to try and keep the actual API
	 * responses as light as possible. It is recommended you cache this data within your application
	 * and check for updates every few days.This method currently holds the data relevant to
	 * building image URLs as well as the change key map.To build an image URL, you will need 3
	 * pieces of data. The base_url, size and file_path. Simply combine them all and you will have a
	 * fully qualified URL.
	 */
	@GET("/configuration")
	def TmdbConfiguration getConfiguration()

	/**
	 * Get the basic movie information for a specific movie id.
	 * 
	 * @param id The identifier of the movie.
	 * @param language ISO 639-1 code.
	 */
	@GET("/movie/{id}")
	def TmdbMovie getMovie(
		@Path("id") Integer id,
		@Query("language") String language
	)

	/**
	 * Get the basic collection information for a specific collection id.
	 * 
	 * @param id The identifier of the movie collection.
	 * @param language ISO 639-1 code.
	 */
	@GET("/collection/{id}")
	def TmdbMovieCollection getMovieCollection(
		@Path("id") Integer id,
		@Query("language") String language
	)

	/**
	 * Get the primary information about a TV series by id.
	 * 
	 * @param id The identifier of the TV show.
	 * @param language ISO 639-1 code.
	 */
	@GET("/tv/{id}?append_to_response=external_ids")
	def TmdbShow getShow(
		@Path("id") Integer id,
		@Query("language") String language
	)

	/**
	 * Get the primary information about a TV series by id.
	 * 
	 * @param id The identifier of the TV show.
	 * @param language ISO 639-1 code.
	 */
	@GET("/tv/{id}/season/{season_number}?append_to_response=external_ids")
	def TmdbShowSeason getShowSeason(
		@Path("id") Integer id,
		@Path("season_number") Integer season_number,
		@Query("language") String language
	)

	/**
	 * Search for movies by title.
	 * 
	 * @param query CGI escaped string
	 * @param page Minimum 1, maximum 1000.
	 * @param language ISO 639-1 code.
	 * @param include_adult Toggle the inclusion of adult titles. Expected value is: true or false
	 * @param year Filter the results release dates to matches that include this value.
	 * @param primary_release_year Filter the results so that only the primary release dates have
	 *        this value.
	 * @param search_type By default, the search type is 'phrase'. This is almost guaranteed the
	 *        option you will want. It's a great all purpose search type and by far the most tuned
	 *        for every day querying. For those wanting more of an "autocomplete" type search, set
	 *        this option to 'ngram'.
	 */
	@GET("/search/movie")
	def SearchResultMovie searchMovie(
		@Query("query") String query,
		@Query("page") Integer page,
		@Query("language") String language,
		@Query("include_adult") Boolean first_air_date_year,
		@Query("year") Integer year,
		@Query("search_type") String search_type
	)

	/**
	 * Search for TV shows by title.
	 * 
	 * @param query CGI escaped string
	 * @param page Minimum 1, maximum 1000.
	 * @param language ISO 639-1 code.
	 * @param first_air_date_year Filter the results to only match shows that have a air date with
	 *        with value.
	 * @param search_type By default, the search type is 'phrase'. This is almost guaranteed the
	 *        option you will want. It's a great all purpose search type and by far the most tuned
	 *        for every day querying. For those wanting more of an "autocomplete" type search, set
	 *        this option to 'ngram'.
	 */
	@GET("/search/tv")
	def SearchResultShow searchShow(
		@Query("query") String query,
		@Query("page") Integer page,
		@Query("language") String language,
		@Query("first_air_date_year") Integer first_air_date_year,
		@Query("search_type") String search_type
	)
}
