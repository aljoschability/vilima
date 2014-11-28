package com.aljoschability.vilima.scraper.tmdb.internal

import java.util.Collection
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbShow {
	List<Integer> episode_run_time
	String first_air_date
	List<TmdbGenre> genres
	Integer id
	String last_air_date
	String name
	Collection<TmdbShowSeason> seasons
	String status
	Double vote_average
	Integer vote_count
	Map<String, String> external_ids
}
