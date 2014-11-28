package com.aljoschability.vilima.scraper.tmdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import java.util.List

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbMovieCollection {
	Integer id
	String name
	String overview
	List<TmdbMovie> parts
}
