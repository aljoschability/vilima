package com.aljoschability.vilima.dapro.tvdb

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import org.simpleframework.xml.ElementList
import org.simpleframework.xml.Root

@EqualsHashCode @ToString @Accessors @Root(name="Data")
class SearchSeriesData {
	@ElementList(inline=true) List<SearchSeriesRecord> Series
}
