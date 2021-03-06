package com.aljoschability.vilima.scraper.tmdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbEpisode {
	Integer id
	Integer season_number
	Integer episode_number
	String name
	String air_date
	Double vote_average
	Integer vote_count
}
