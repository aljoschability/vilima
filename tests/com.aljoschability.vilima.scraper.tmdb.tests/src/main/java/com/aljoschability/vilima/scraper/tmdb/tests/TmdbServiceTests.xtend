package com.aljoschability.vilima.scraper.tmdb.tests

import com.aljoschability.vilima.scraper.tmdb.TmdbService
import com.google.common.base.Charsets
import com.google.common.io.Files
import java.io.File
import org.junit.After
import org.junit.Before
import org.junit.Test
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel

class TmdbServiceTests {
	TmdbService service

	@Test
	def void testGetConfiguration() {
		println("#testGetConfiguration()")
		println(service.getConfiguration())
	}

	@Test
	def void testGetMovie() {
		println("#testGetMovie()")
		println(service.getMovie(156022, null))
	}

	@Test
	def void testGetMovieCollection() {
		println("#testGetMovieCollection()")
		println(service.getMovieCollection(2344, null))
	}

	@Test
	def void testGetShow() {
		println("#testGetShow()")
		println(service.getShow(46296, null))
	}

	@Test
	def void testGetShowSeason() {
		println("#testGetShowSeason()")
		println(service.getShowSeason(32798, 4, null))
	}

	@Test
	def void testSearchMovie() {
		println("#testSearchMovie()")
		println(service.searchMovie("The Equalizer", null, "de", null, null, null))
	}

	@Test
	def void testSearchShow() {
		println("#testSearchShow()")
		println(service.searchShow("Hawaii Five-0", null, null, null, null))
	}

	@Before def void start() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "https://api.themoviedb.org/3"
		builder.requestInterceptor = [
			addHeader("Accept", "application/json")
			addQueryParam("api_key", apiKey)
		]

		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		service = adapter.create(TmdbService)
	}

	@After def void stop() {
		service = null
	}

	@Deprecated
	def private static String getApiKey() {
		val path = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\apis\themoviedb.txt'''

		return Files::readFirstLine(new File(path), Charsets::UTF_8)
	}
}
