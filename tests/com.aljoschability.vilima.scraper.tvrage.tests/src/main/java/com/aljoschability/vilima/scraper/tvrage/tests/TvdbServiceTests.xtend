package com.aljoschability.vilima.scraper.tvrage.tests

import com.aljoschability.vilima.scraper.tvrage.TvdbService
import org.junit.After
import org.junit.Before
import org.junit.Test
import retrofit.RestAdapter
import retrofit.RestAdapter.LogLevel
import retrofit.converter.SimpleXMLConverter

class TvRageServiceTests {
	TvdbService service

	@Test
	def void testSearch() {
		println(service.search("Stromberg"))
	}

	@Test
	def void testFullShowInfo() {
		println(service.fullShowInfo(16623))
	}

	@Test
	def void testEpisodeinfo() {
		println(service.episodeinfo("Stromberg", 1, "2x5"))
	}

	@Before def void start() {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://services.tvrage.com"
		builder.converter = new SimpleXMLConverter(false)

		val adapter = builder.build
		adapter.logLevel = LogLevel::FULL

		service = adapter.create(TvdbService)
	}

	@After def void stop() {
		service = null
	}
}
