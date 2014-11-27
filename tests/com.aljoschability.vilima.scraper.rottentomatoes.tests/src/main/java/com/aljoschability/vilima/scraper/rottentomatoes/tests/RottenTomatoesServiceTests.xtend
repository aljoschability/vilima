package com.aljoschability.vilima.scraper.rottentomatoes.tests

import com.aljoschability.vilima.scraper.rottentomatoes.RottenTomatoesService
import com.google.common.base.Charsets
import com.google.common.io.Files
import java.io.File
import org.junit.Test
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel

class RottenTomatoesServiceTests {
	@Deprecated
	def private static String getApiKey() {
		val path = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\apis\rottentomatoes.txt'''

		return Files::readFirstLine(new File(path), Charsets::UTF_8)
	}

	@Test def void testMovieSearch() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://api.rottentomatoes.com"
		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		val service = adapter.create(RottenTomatoesService)

		val query = "Matrix"

		println(service.searchMovies(apiKey, query, 10, 1))
	}
}
