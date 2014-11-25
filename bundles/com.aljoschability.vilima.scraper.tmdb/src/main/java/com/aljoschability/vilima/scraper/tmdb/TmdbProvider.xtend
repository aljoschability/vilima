package com.aljoschability.vilima.scraper.tmdb

import com.aljoschability.vilima.scraper.MovieCandidate
import com.aljoschability.vilima.scraper.ShowCandidate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel
import retrofit.http.GET
import retrofit.http.Headers
import retrofit.http.Path
import retrofit.http.Query
import com.google.common.io.Files
import java.io.File
import com.google.common.base.Charsets

@Accessors @EqualsHashCode @ToString
class SearchResultShow {
	List<SearchResultShowRecord> results
	Integer page
	Integer total_pages
	Integer total_results
}

@Accessors @EqualsHashCode @ToString
class SearchResultShowRecord implements ShowCandidate {
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

	override getTitle() {
		name
	}

	override getReleaseDate() {
		first_air_date
	}

}

@Accessors @EqualsHashCode @ToString
class SearchResultMovie {
	List<SearchResultMovieRecord> results
	Integer page
	Integer total_pages
	Integer total_results
}

@Accessors @EqualsHashCode @ToString
class SearchResultMovieRecord implements MovieCandidate {
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

	override getSummary() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getGenres() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getReleaseDate() {
		release_date
	}

	override getRating() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getInfoUrl() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getPosterUrl() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getIdentifiers() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}

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

	/**
	 * Get the external ids that we have stored for a TV series.
	 * 
	 * @param api_key The API key.
	 * @param language ISO 639-1 code.
	 */
	@Headers("Accept: application/json")
	@GET("/tv/{id}/external_ids")
	def ExternalIdShowRecord external_ids(
		@Query("api_key") String api_key,
		@Path("id") Integer id,
		@Query("language") String language
	)

	@Headers("Accept: application/json")
	@GET("/movie/{id}")
	def SearchResultMovieRecord getMovie(
		@Query("api_key") String api_key,
		@Path("id") Integer id,
		@Query("language") String language
	)
}

@ToString @EqualsHashCode @Accessors
class ExternalIdShowRecord {
	String imdb_id
	String freebase_id
	String freebase_mid
	Integer id
	Integer tvdb_id
	Integer tvrage_id
}

/**
 * http://docs.themoviedb.apiary.io/#reference/tv/tvidexternalids/get
 */
class TmdbProvider {

	static val API_KEY = Files::readFirstLine(
		new File('''C:\dev\repos\github.com\aljoschability\vilima\__TODO\apis\themoviedb.txt'''), Charsets::UTF_8)

	def static void main(String[] args) {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "https://api.themoviedb.org/3"
		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		val service = adapter.create(TmdbService)

		// testShow(service)
		testMovie(service)
	}

	def static private void testMovie(TmdbService service) {
		val movieResult = service.searchMovie(API_KEY, "The Equalizer", null, null, null, null, null)

		val id = movieResult.results.head.id

		val m = service.getMovie(API_KEY, id, null)

		println(m)
	}

	def static private void testShow(TmdbService service) {
		val showResult = service.searchShow(API_KEY, "Krömer", null, null, null, null)
		println(showResult)

		val id = showResult.results.get(0).id

		val showIds = service.external_ids(API_KEY, id, null)
		println(showIds)
	}

	def List<MovieCandidate> getMovies(String query) {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "https://api.themoviedb.org/3"

		val adapter = builder.build

		val service = adapter.create(TmdbService)

		val showResult = service.searchMovie(API_KEY, query, null, null, null, null, null)

		val List<MovieCandidate> x = newArrayList
		for (res : showResult.results) {
			x += res
		}

		return x
	}

	def List<ShowCandidate> getShows(String query) {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "https://api.themoviedb.org/3"

		val adapter = builder.build

		val service = adapter.create(TmdbService)

		val showResult = service.searchShow(API_KEY, query, null, null, null, null)

		val List<ShowCandidate> x = newArrayList
		for (res : showResult.results) {
			x += res
		}

		return x
	}
}
