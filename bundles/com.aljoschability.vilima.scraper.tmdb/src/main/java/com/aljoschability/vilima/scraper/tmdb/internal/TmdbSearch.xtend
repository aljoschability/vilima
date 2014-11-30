package com.aljoschability.vilima.scraper.tmdb.internal

import com.aljoschability.vilima.scraper.ShowCandidate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

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
