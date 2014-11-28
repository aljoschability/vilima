package com.aljoschability.vilima.scraper.omdb.tests

import com.aljoschability.vilima.scraper.omdb.OmdbService
import org.junit.After
import org.junit.Before
import org.junit.Test
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel

class OmdbServiceTests {
	OmdbService service

	@Test
	def void testGetMovie() {
		println(service.getMovie("tt0133093"))
	}

	@Test
	def void testGetShow() {
		println(service.getShow("tt1442449"))
	}

	@Test
	def void testSearchMovie() {
		println(service.searchMovie("Matrix", null))
	}

	@Test
	def void testSearchShow() {
		println(service.searchShow("Spartacus", null))
	}

	@Before def void start() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://www.omdbapi.com"

		//		builder.requestInterceptor = [
		//			addHeader("Accept", "application/json")
		//			addQueryParam("api_key", apiKey)
		//		]
		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		service = adapter.create(OmdbService)
	}

	@After def void stop() {
		service = null
	}
}
