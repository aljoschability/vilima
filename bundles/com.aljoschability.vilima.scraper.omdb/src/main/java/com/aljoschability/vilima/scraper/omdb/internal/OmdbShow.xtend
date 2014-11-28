package com.aljoschability.vilima.scraper.omdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @EqualsHashCode @ToString(skipNulls=false)
class OmdbShow {
	String Title
	String Released
	String Runtime
	String Genre
	String Plot
	String Poster
}
