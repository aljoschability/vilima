package com.aljoschability.vilima.dapro.tvdb

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import org.simpleframework.xml.Element
import org.simpleframework.xml.Root

@EqualsHashCode @ToString @Accessors @Root(name="Series")
class BaseSeriesRecord {

	/**
	 * An unsigned integer assigned by our site to the series. It
	 * does not change and will always represent the same series.
	 * Cannot be null.
	 */
	@Element int id

	/**
	 * A pipe delimited string of actors in plain text. Begins and
	 * ends with a pipe even if no actors are listed. Cannot be null.
	 */
	@Element String Actors

	/**
	 * The full name in English for the day of the week the series
	 * airs in plain text. Can be null.
	 */
	@Element(required=false) String Airs_DayOfWeek

	/**
	 * A string indicating the time of day the series airs on its
	 * original network. Format "HH:MM AM/PM". Can be null.
	 */
	@Element(required=false) String Airs_Time

	/**
	 * The rating given to the series based on the US rating system.
	 * Can be null or a 4-5 character string.
	 */
	@Element(required=false) String ContentRating

	/**
	 * A string containing the date the series first aired in plain
	 * text using the format "YYYY-MM-DD". Can be null.
	 */
	@Element(required=false) String FirstAired

	/**
	 * Pipe delimited list of genres in plain text. Begins and ends
	 * with a | but may also be null.
	 */
	@Element(required=false) String Genre

	/**
	 * An alphanumeric string containing the IMDB ID for the series.
	 * Can be null.
	 */
	@Element(required=false) String IMDB_ID

	/**
	 * A two character string indicating the language in accordance
	 * with ISO-639-1. Cannot be null.
	 */
	@Element String Language

	/**
	 * A string containing the network name in plain text. Can be null.
	 */
	@Element(required=false) String Network

	/**
	 * Not in use, will be an unsigned integer if ever used. Can be null.
	 */
	@Element(required=false) int NetworkID

	/**
	 * A string containing the overview in the language requested.
	 * Will return the English overview if no translation is available
	 * in the language requested. Can be null.
	 */
	@Element(required=false) String Overview

	/**
	 * The average rating our users have rated the series out of 10,
	 * rounded to 1 decimal place. Can be null.
	 */
	@Element(required=false) double Rating

	/**
	 * An unsigned integer representing the number of users who have
	 * rated the series. Can be null.
	 */
	@Element(required=false) int RatingCount

	/**
	 * An unsigned integer representing the runtime of the series
	 * in minutes. Can be null.
	 */
	@Element(required=false) int Runtime

	/**
	 * Deprecated. An unsigned integer representing the series ID at
	 * tv.com. As TV.com now only uses these ID's internally it's of
	 * little use and no longer updated. Can be null.
	 */
	@Element(required=false) int SeriesID

	/**
	 * A string containing the series name in the language you
	 * requested. Will return the English name if no translation is
	 * found in the language requested. Can be null if the name isn't
	 * known in the requested language or English.
	 */
	@Element(required=false) String SeriesName

	/**
	 * A string containing either "Ended" or "Continuing". Can be null.
	 */
	@Element(required=false) String Status

	/**
	 * A string containing the date/time the series was added to our
	 * site in the format "YYYY-MM-DD HH:MM:SS" based on a 24 hour
	 * clock. Is null for older series.
	 */
	@Element(required=false) String added

	/**
	 * An unsigned integer. The ID of the user on our site who added
	 * the series to our database. Is null for older series.
	 */
	@Element(required=false) int addedBy

	/**
	 * A string which should be appended to &lt;mirrorpath&gt;/banners/
	 * to determine the actual location of the artwork. Returns the highest
	 * voted banner for the requested series. Can be null.
	 */
	@Element(required=false) String banner

	/**
	 * A string which should be appended to &lt;mirrorpath&gt;/banners/
	 * to determine the actual location of the artwork. Returns the highest
	 * voted fanart for the requested series. Can be null.
	 */
	@Element(required=false) String fanart

	/**
	 * Unix time stamp indicating the last time any changes were made
	 * to the series. Can be null.
	 */
	@Element(required=false) long lastupdated

	/**
	 * A string which should be appended to &lt;mirrorpath&gt;/banners/
	 * to determine the actual location of the artwork. Returns the highest
	 * voted poster for the requested series. Can be null.
	 */
	@Element(required=false) String poster

	/**
	 * NOT DOCUMENTED
	 */
	@Element(required=false) int tms_wanted_old

	/**
	 * An alphanumeric string containing the zap2it id. Can be null.
	 */
	@Element(required=false) String zap2it_id
}
