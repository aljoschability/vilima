package com.aljoschability.vilima.scraper.tvdb.tests

import com.aljoschability.vilima.scraper.tvdb.TvdbService
import com.google.common.base.Charsets
import com.google.common.io.Files
import java.io.File
import org.junit.After
import org.junit.Before
import org.junit.Test
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel

class TvdbServiceTests {
	TvdbService service

	@Test
	def void testGetShow() {
		println(service.getShow(76258, "en"))
	}

	@Test
	def void testSearchShow() {
		println(service.searchShow("Spartacus", "en"))
	}

	@Before def void start() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://thetvdb.com"
		builder.requestInterceptor = [
			addPathParam("apikey", apiKey)
		]

		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		service = adapter.create(TvdbService)
	}

	@After def void stop() {
		service = null
	}

	@Deprecated
	def private static String getApiKey() {
		val path = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\apis\thetvdb.txt'''

		return Files::readFirstLine(new File(path), Charsets::UTF_8)
	}
}
