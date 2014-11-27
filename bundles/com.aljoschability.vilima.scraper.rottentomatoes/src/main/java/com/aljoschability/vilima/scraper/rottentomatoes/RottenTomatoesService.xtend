package com.aljoschability.vilima.scraper.rottentomatoes

import retrofit.client.Response
import retrofit.http.GET
import retrofit.http.Path
import retrofit.http.Query

interface RottenTomatoesService {

	/**
	 * Search for a movie.
	 * 
	 * @param apikey The API key.
	 * @param q The plain text search query to search for a movie.
	 * @param page_limit The amount of movie search results to show per page.
	 * @param page The selected page of movie search results.
	 */
	@GET("/api/public/v1.0/movies.json")
	def Response searchMovies(
		@Query("apikey") String apikey,
		@Query("q") String q,
		@Query("page_limit") Integer page_limit,
		@Query("page") Integer page
	)

	/**
	 * Get all details about a movie.
	 * 
	 * @param id The Movie ID. You can use the movies search endpoint or peruse
	 *           the lists of movies/dvds to get the Movie ID.
	 */
	@GET("/api/public/v1.0/movies/{id}.json")
	def Response getMovieInfo(
		@Query("apikey") String apikey,
		@Path("id") String id
	)
}
