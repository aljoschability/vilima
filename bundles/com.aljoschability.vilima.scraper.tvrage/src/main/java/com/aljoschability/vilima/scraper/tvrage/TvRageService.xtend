package com.aljoschability.vilima.scraper.tvrage

import retrofit.client.Response
import retrofit.http.GET
import retrofit.http.Query

interface TvdbService {

	/**
	 * Search
	 */
	@GET("/feeds/search.php")
	def Response search(
		@Query("show") String show
	)

	/**
	 * Detailed Search
	 */
	@GET("/feeds/full_search.php")
	def Response fullSearch(
		@Query("show") String show
	)

	/**
	 * Show Info
	 */
	@GET("/feeds/showinfo.php")
	def Response showInfo(
		@Query("sid") Integer sid
	)

	/**
	 * Episode List
	 */
	@GET("/feeds/episode_list.php")
	def Response episodeList(
		@Query("sid") Integer sid
	)

	/**
	 * Episode Info
	 * 
	 * @param ep <code>{SEASON}x{EPISODE}</code>
	 */
	@GET("/feeds/episodeinfo.php")
	def Response episodeinfo(
		@Query("show") String show,
		@Query("exact") Integer exact,
		@Query("ep") String ep
	)

	/**
	 * Show Info + Episode List
	 */
	@GET("/feeds/full_show_info.php")
	def Response fullShowInfo(
		@Query("sid") Integer sid
	)

	/**
	 * Full Show List
	 */
	@GET("/feeds/show_list.php")
	def Response showList(
		@Query("sid") Integer sid
	)
}
