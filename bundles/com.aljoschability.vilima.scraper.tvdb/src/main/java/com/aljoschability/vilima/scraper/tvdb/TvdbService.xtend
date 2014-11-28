package com.aljoschability.vilima.scraper.tvdb

import com.aljoschability.vilima.scraper.tvdb.internal.FullSeriesRecord
import com.aljoschability.vilima.scraper.tvdb.internal.SearchSeriesData
import retrofit.http.GET
import retrofit.http.Path
import retrofit.http.Query

interface TvdbService {

	/**
	 * This interface allows you to find the id of a series based on its name.
	 * 
	 * @param seriesname This is the string you want to search for. If there is an exact match for the parameter, it will be the first result returned.
	 * @param language This is the abbreviation for the language you want to search in. If omitted, it will default to en (English). This may also be set to all, which will search ALL translations for <seriesname>.
	 * @param user This is a users account Identifier. If given it will use the language their account is set to. The account ID can be found by going to http://thetvdb.com/?tab=userinfo
	 */
	@GET("/api/GetSeries.php")
	def SearchSeriesData getSeries(
		@Query("seriesname") String seriesname,
		@Query("language") String language
	)

	/**
	 * Used to find shows by unique ID's used on other sites.
	 * 
	 * @param imdbid The imdb id you're trying to find. Do not use with &lt;zap2itid&gt;
	 * @param zap2it The Zap2it / SchedulesDirect ID you're trying to find. Do not use with &lt;imdb&gt;
	 * @param language The language abbreviation, if not provided English is used.
	 */
	@GET("/api/GetSeriesByRemoteID.php")
	def SearchSeriesData getSeriesByRemoteID(
		@Query("imdbid") String imdbid,
		@Query("zap2it") String zap2it,
		@Query("language") String language
	)

	/**
	 * <p>This interface returns the full episode XML if an episode is found in the series that has the correct air date. This is useful if you are looking up shows that don't contain season and episode info but rather have the date in the title.
	 * 
	 * <p>If an empty XML set is returned it means there was no episode in that series with the airdate you specified.
	 * 
	 * <p>If there is more than one episode for the series and air date you supplied only one will be returned.
	 * 
	 * @param apikey This is the API key that is registered to your application.
	 * @param seriesid This is the seriesid for the series you want to use for finding episodes.
	 * @param airdate This is the date the episode aired on you are trying to lookup. This can be supplied in any valid date type. Examples:
	 * <ul>
	 * <li>2008-01-01
	 * <li>2008-1-1
	 * <li>January 1, 2008
	 * <li>1/1/2008
	 * <li>etc
	 * </ul>
	 * @param language This field is optional. If it isn't supplied the interface defaults to using 'en' as its language type. When you supply a language id, it will first try to find translation data for the language id you specified. If non can be found it will return English.
	 */
	@GET("/api/GetSeriesByRemoteID.php")
	def SearchSeriesData getEpisodeByAirDate(
		@Query("seriesid") Integer seriesid,
		@Query("airdate") String airdate,
		@Query("language") String language
	)

	/**
	 * The Full Series Record contains all of the information available
	 * about a series including information about all the episodes.
	 * Please note that this file is often quite large (100's of kb) and
	 * is available in zipped format. Please try using the zipped format
	 * whenever possible to conserve bandwidth.
	 */
	@GET("/api/{apikey}/series/{seriesid}/all/{language}.xml")
	def FullSeriesRecord getFullSeriesRecord(
		@Path("seriesid") int seriesid,
		@Path("language") String language
	)
}
