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
import retrofit.converter.SimpleXMLConverter

class TvdbServiceTests {
	TvdbService service

	@Test
	def void testGetSeries() {
		println(service.getSeries("Modern Family", "en"))
	}

	@Test
	def void testGetSeriesByRemoteID() {
		println(service.getSeriesByRemoteID("tt1442437", null, "en"))
	}

	@Test
	def void testGetFullSeriesRecord() {
		println(service.getFullSeriesRecord(95011, "en"))
	}

	@Before def void start() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://thetvdb.com"
		builder.requestInterceptor = [
			addPathParam("apikey", apiKey)
		]
		builder.converter = new SimpleXMLConverter

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
