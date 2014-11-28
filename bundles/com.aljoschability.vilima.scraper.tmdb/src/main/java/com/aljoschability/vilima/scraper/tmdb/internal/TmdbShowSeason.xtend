package com.aljoschability.vilima.scraper.tmdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import java.util.Map
import java.util.List

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbShowSeason {
	Integer id
	Integer season_number
	String air_date
	Integer episode_count
	List<TmdbEpisode> episodes
	Map<String, String> external_ids
}
