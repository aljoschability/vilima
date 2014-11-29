package com.aljoschability.vilima.scraper.tmdb

import com.aljoschability.vilima.scraper.MovieScraper
import com.google.common.base.Charsets
import com.google.common.io.Files
import java.io.File
import retrofit.RestAdapter
import com.aljoschability.vilima.scraper.MovieCandidate
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import java.util.List
import java.util.Map
import com.aljoschability.vilima.ScrapeMovie
import com.aljoschability.vilima.VilimaFactory
import retrofit.RestAdapter.LogLevel

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class MovieCandidateImpl implements MovieCandidate {
	Map<String, String> identifiers
	String title
	String summary
	List<String> genres
	String releaseDate
	Double rating
	String infoUrl
	String posterUrl
	String network
	String tagline
	Integer runtime
	Integer ratingCount
	Float ratingPercentage
}

class TmdbMovieScraper implements MovieScraper {
	TmdbService service

	new() {

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

	override findMovie(String query) {
		val result = service.searchMovie(query, null, null, null, null, null)

		val List<ScrapeMovie> list = newArrayList
		for (r : result.results) {
			val m = VilimaFactory::eINSTANCE.createScrapeMovie
			m.title = r.title
			m.releaseDate = r.release_date
			m.voteCount = r.vote_count
			m.votePercentage = (r.vote_average / 10d) * 100d
			list += m
		}

		return list
	}

	override getMovie(String identifier) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	@Deprecated
	def private static String getApiKey() {
		val path = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\apis\themoviedb.txt'''

		return Files::readFirstLine(new File(path), Charsets::UTF_8)
	}
}
