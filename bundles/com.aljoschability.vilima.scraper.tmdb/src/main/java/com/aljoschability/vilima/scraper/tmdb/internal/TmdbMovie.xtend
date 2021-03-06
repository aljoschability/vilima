package com.aljoschability.vilima.scraper.tmdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import java.util.List

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbMovie {
	List<TmdbGenre> genres
	Double vote_average
	Integer vote_count
	String status
	String overview
	String poster_path
	String homepage
	Integer id
	String original_title
	String title
	String tagline
	String release_date
	Integer runtime
	TmdbMovieCollection belongs_to_collection

	String imdb_id
}
