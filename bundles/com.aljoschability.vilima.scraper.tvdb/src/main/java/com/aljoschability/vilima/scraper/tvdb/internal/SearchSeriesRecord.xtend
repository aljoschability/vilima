package com.aljoschability.vilima.scraper.tvdb.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import org.simpleframework.xml.Element
import org.simpleframework.xml.Root

@EqualsHashCode @ToString @Accessors @Root(name="Series")
class SearchSeriesRecord {

	/**
	 * Returns an unsigned integer. Both values are exactly the same and always
	 * returned. &lt;seriesid&gt; is preferred, &lt;id&gt; is only included to
	 * be backwards compatible with the old API and is deprecated.
	 */
	@Element int seriesid

	/**
	 * Returns an unsigned integer. Both values are exactly the same and always
	 * returned. &lt;seriesid&gt; is preferred, &lt;id&gt; is only included to
	 * be backwards compatible with the old API and is deprecated.
	 */
	@Element int id

	/**
	 * Returns a two digit string indicating the language.
	 */
	@Element String language

	/**
	 * Returns a string with the series name for the language indicated
	 */
	@Element String SeriesName

	/**
	 * Returns a pipe "|" delimited list of alias names if the series has
	 * any other names in that language.
	 */
	@Element(required=false) String AliasNames

	/**
	 * Returns the relative path to the highest rated banner for this series.
	 * Append &lt;mirrorpath&gt; to the start of it to get the absolute path.
	 */
	@Element String banner

	// #######################
	/**
	 * Returns the overview for the series
	 */
	@Element(required=false) String Overview

	/**
	 * Returns the first aired date for the series in the "YYYY-MM-DD" format.
	 */
	@Element String FirstAired

	/**
	 * Returns the IMDB id for the series if known.
	 */
	@Element(required=false) String IMDB_ID

	/**
	 * Returns the zap2it ID if known.
	 */
	@Element(required=false) String zap2it_id

	/**
	 * Returns the Network name if known.
	 */
	@Element(required=false) String Network
}
