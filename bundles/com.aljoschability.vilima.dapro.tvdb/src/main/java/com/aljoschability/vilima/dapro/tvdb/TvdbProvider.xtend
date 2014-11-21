package com.aljoschability.vilima.dapro.tvdb

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.jobs.Job
import retrofit.RestAdapter
import retrofit.converter.SimpleXMLConverter

class TvdbProvider {
	def static void main(String[] args) {
		val builder = new RestAdapter.Builder()
		builder.endpoint = "http://thetvdb.com/api"
		builder.converter = new SimpleXMLConverter

		val adapter = builder.build

		val service = adapter.create(TvdbService)

		val apikey = ""

		//		adapter.logLevel = LogLevel::FULL
		val show = service.getSeries("Krömer", "all", null)

		println(show)

		val full = service.getFullSeriesRecord(apikey, 261675, "en")

		println(full)
	}
}

class TvdbDiscovererJob extends Job {
	new() {
		super("Discovering something from trakt.tv")
	}

	override run(IProgressMonitor monitor) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
