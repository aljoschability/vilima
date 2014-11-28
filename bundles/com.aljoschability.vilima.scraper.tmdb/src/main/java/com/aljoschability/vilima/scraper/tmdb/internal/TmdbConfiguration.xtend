package com.aljoschability.vilima.scraper.tmdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import java.util.List

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbConfiguration {
	TmdbConfigurationImages images
}

@Accessors @EqualsHashCode @ToString(skipNulls=true)
class TmdbConfigurationImages {
	String secure_base_url
	List<String> poster_sizes
}
