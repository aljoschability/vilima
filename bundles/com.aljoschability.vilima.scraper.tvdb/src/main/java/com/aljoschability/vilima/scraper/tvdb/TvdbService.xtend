package com.aljoschability.vilima.scraper.tvdb

import retrofit.client.Response
import retrofit.http.GET
import retrofit.http.Path
import retrofit.http.Query

interface TvdbService {

	/**
	 * @param seriesid The identifier of the series.
	 * @param language The language to scrape. Use <code>en</code> instead of <code>null</code>.
	 */
	@GET("/api/{apikey}/series/{seriesid}/all/{language}.xml")
	def Response getShow(
		@Path("seriesid") Integer seriesid,
		@Path("language") String language
	)

	/**
	 * @param seriesname This is the string you want to search for. If there is an exact match for
	 *        the parameter, it will be the first result returned.
	 * @param language This is the abbreviation for the language you want to search in. If omitted,
	 *        it will default to en (English). This may also be set to all, which will search ALL
	 *        translations for seriesname.
	 */
	@GET("/api/GetSeries.php")
	def Response searchShow(
		@Query("seriesname") String seriesname,
		@Query("language") String language
	)
}
