package com.aljoschability.vilima.dapro.tmdb

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import retrofit.RestAdapter
import retrofit.http.GET
import retrofit.http.Headers
import retrofit.http.Query

interface TmdbService {
	@Headers("Accept: application/json")
	@GET("/search/tv")
	def SearchResultShow searchShow(
		@Query("api_key") String api_key,
		@Query("query") String query,
		@Query("page") Integer page,
		@Query("language") String language,
		@Query("first_air_date_year") Integer first_air_date_year,
		@Query("search_type") String search_type
	)

	/**
	 * Search for movies by title.
	 * 
	 * @param api_key The API key.
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
	@Headers("Accept: application/json")
	@GET("/search/movie")
	def SearchResultMovie searchMovie(
		@Query("api_key") String api_key,
		@Query("query") String query,
		@Query("page") Integer page,
		@Query("language") String language,
		@Query("include_adult") Boolean first_air_date_year,
		@Query("year") Integer year,
		@Query("search_type") String search_type
	)
}

@Accessors @EqualsHashCode @ToString
class SearchResultShow {
	List<SearchResultShowRecord> results
	Integer page
	Integer total_pages
	Integer total_results
}

@Accessors @EqualsHashCode @ToString
class SearchResultShowRecord {
	String backdrop_path
	Integer id
	String original_name
	String first_air_date
	List<String> origin_country
	String poster_path
	Double popularity
	String name
	Float vote_average
	Integer vote_count
}

@Accessors @EqualsHashCode @ToString
class SearchResultMovie {
	List<SearchResultMovieRecord> results
	Integer page
	Integer total_pages
	Integer total_results
}

@Accessors @EqualsHashCode @ToString
class SearchResultMovieRecord {
	Boolean adult
	String backdrop_path
	Integer id
	String original_title
	String release_date
	String poster_path
	Double popularity
	String title
	Boolean video
	Float vote_average
	Integer vote_count
}

/**
 * http://docs.themoviedb.apiary.io/#reference/tv/tvidexternalids/get
 */
class TmdbProvider {
	def static void main(String[] args) {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "https://api.themoviedb.org/3"

		val adapter = builder.build

		val service = adapter.create(TmdbService)

		val apikey = ""

		val showResult = service.searchShow(apikey, "Krömer", null, null, null, null)
		println(showResult)

		val movieResult = service.searchMovie(apikey, "Matrix", null, null, null, null, null)
		println(movieResult)

	//		val showDetails = service.
	}
}
