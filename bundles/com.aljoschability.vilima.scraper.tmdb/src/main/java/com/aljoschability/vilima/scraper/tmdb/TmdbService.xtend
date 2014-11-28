package com.aljoschability.vilima.scraper.tmdb

import com.aljoschability.vilima.scraper.tmdb.internal.SearchResultMovie
import com.aljoschability.vilima.scraper.tmdb.internal.SearchResultMovieRecord
import com.aljoschability.vilima.scraper.tmdb.internal.SearchResultShow
import retrofit.http.GET
import retrofit.http.Path
import retrofit.http.Query

interface TmdbService {

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

	/**
	 * Get the basic movie information for a specific movie id.
	 * 
	 * @param id The identifier of the movie.
	 * @param language ISO 639-1 code.
	 */
	@GET("/movie/{id}")
	def SearchResultMovieRecord getMovie(
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
	def SearchResultMovieRecord getShow(
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
	def SearchResultMovieRecord getSeason(
		@Path("id") Integer id,
		@Path("season_number") Integer season_number,
		@Query("language") String language
	)
}
