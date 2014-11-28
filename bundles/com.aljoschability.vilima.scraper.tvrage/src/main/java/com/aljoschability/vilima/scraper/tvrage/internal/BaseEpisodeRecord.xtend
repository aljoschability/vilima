package com.aljoschability.vilima.scraper.tvrage.internal

import org.eclipse.xtend.lib.annotations.Accessors
import org.simpleframework.xml.Element
import org.simpleframework.xml.Root
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@EqualsHashCode @ToString @Accessors @Root(name="Episode")
class BaseEpisodeRecord {

	/**
	 * An unsigned integer assigned by our site to the episode. Cannot be null.
	 */
	@Element int id

	/**
	 * An unsigned integer or decimal. Cannot be null. This returns the value
	 * of DVD_episodenumber if that field is not null. Otherwise it returns the
	 * value from EpisodeNumber. The field can be used as a simple way of prioritizing
	 * DVD order over aired order in your program. In general it's best to avoid using
	 * this field as you can accomplish the same task locally and have more control if
	 * you use the DVD_episodenumber and EpisodeNumber fields separately.
	 */
	@Element float Combined_episodenumber

	/**
	 * An unsigned integer or decimal. Cannot be null. This returns the value of
	 * DVD_season if that field is not null. Otherwise it returns the value from
	 * SeasonNumber. The field can be used as a simple way of prioritizing DVD order
	 * over aired order in your program. In general it's best to avoid using this field
	 * as you can accomplish the same task locally and have more control if you use the
	 * DVD_season and SeasonNumber fields separately.
	 */
	@Element float Combined_season

	/**
	 * Deprecated, was meant to be used to aid in scrapping of actual DVD's but has never
	 * been populated properly. Any information returned in this field shouldn't be
	 * trusted. Will usually be null.
	 */
	@Element(required=false) String DVD_chapter

	/**
	 * Deprecated, was meant to be used to aid in scrapping of actual DVD's but has never
	 * been populated properly. Any information returned in this field shouldn't be
	 * trusted. Will usually be null.
	 */
	@Element(required=false) String DVD_discid

	/**
	 * A decimal with one decimal and can be used to join episodes together. Can be null,
	 * usually used to join episodes that aired as two episodes but were released on DVD
	 * as a single episode. If you see an episode 1.1 and 1.2 that means both records
	 * should be combined to make episode 1. Cartoons are also known to combine up to 9
	 * episodes together, for example Animaniacs season two.
	 */
	@Element(required=false) float DVD_episodenumber

	/**
	 * An unsigned integer indicating the season the episode was in according to the DVD
	 * release. Usually is the same as EpisodeNumber but can be different.
	 */
	@Element(required=false) int DVD_season

	/**
	 * A pipe delimited string of directors in plain text. Can be null.
	 */
	@Element(required=false) String Director

	/**
	 * <p>An unsigned integer from 1-6.</p>
	 * <ul>
	 * <li>1. 4:3 - Indicates an image is a proper 4:3 (1.31 to 1.35) aspect ratio.</li>
	 * <li>2. 16:9 - Indicates an image is a proper 16:9 (1.739 to 1.818) aspect ratio.</li>
	 * <li>3. Invalid Aspect Ratio - Indicates anything not in a 4:3 or 16:9 ratio. We don't
	 * bother listing any other non standard ratios.</li>
	 * <li>4. Image too Small - Just means the image is smaller then 300x170.</li>
	 * <li>5. Black Bars - Indicates there are black bars along one or all four sides of</li>
	 * the image.
	 * <li>6. Improper Action Shot - Could mean a number of things, usually used when someone</li>
	 * uploads a promotional picture that isn't actually from that episode but does refrence the
	 * episode, it could also mean it's a credit shot or that there is writting all over it. It's
	 * rarely used since most times an image would just be outright deleted if it falls in this
	 * category.</li>
	 * </ul>
	 * <p>It can also be null. If it's 1 or 2 the site assumes it's a proper image, anything
	 * above 2 is considered incorrect and can be replaced by anyone with an account.</p> 
	 */
	@Element(required=false) int EpImgFlag

	/**
	 * A string containing the episode name in the language requested. Will return the English
	 * name if no translation is available in the language requested.
	 */
	@Element(required=false) String EpisodeName

	/**
	 * An unsigned integer representing the episode number in its season according to the
	 * aired order. Cannot be null.
	 */
	@Element(required=false) int EpisodeNumber

	/**
	 * A string containing the date the series first aired in plain text using the format
	 * "YYYY-MM-DD". Can be null.
	 */
	@Element(required=false) String FirstAired

	/**
	 * A pipe delimited string of guest stars in plain text. Can be null.
	 */
	@Element(required=false) String GuestStars

	/**
	 * An alphanumeric string containing the IMDB ID for the series. Can be null.
	 */
	@Element(required=false) String IMDB_ID

	/**
	 * A two character string indicating the language in accordance with ISO-639-1.
	 * Cannot be null.
	 */
	@Element(required=false) String Language

	/**
	 * A string containing the overview in the language requested. Will return the English
	 * overview if no translation is available in the language requested. Can be null.
	 */
	@Element(required=false) String Overview

	/**
	 * An alphanumeric string. Can be null.
	 */
	@Element(required=false) String ProductionCode

	/**
	 * The average rating our users have rated the series out of 10, rounded to 1 decimal
	 * place. Can be null.
	 */
	@Element(required=false) float Rating

	/**
	 * An unsigned integer representing the number of users who have rated the series.
	 * Can be null.
	 */
	@Element(required=false) int RatingCount

	/**
	 * An unsigned integer representing the season number for the episode according to
	 * the aired order. Cannot be null.
	 */
	@Element(required=false) int SeasonNumber

	/**
	 * A pipe delimited string of writers in plain text. Can be null.
	 */
	@Element(required=false) String Writer

	/**
	 * An unsigned integer. Can be null. Indicates the absolute episode number and
	 * completely ignores seasons. In others words a series with 20 episodes per season
	 * will have Season 3 episode 10 listed as 50. The field is mostly used with cartoons
	 * and anime series as they may have ambiguous seasons making it easier to use this field.
	 */
	@Element(required=false) int absolute_number

	/**
	 * An unsigned integer indicating the season number this episode comes after. This field
	 * is only available for special episodes. Can be null.
	 */
	@Element(required=false) int airsafter_season

	/**
	 * An unsigned integer indicating the episode number this special episode airs before.
	 * Must be used in conjunction with airsbefore_season, do not with airsafter_season.
	 * This field is only available for special episodes. Can be null.
	 */
	@Element(required=false) int airsbefore_episode

	/**
	 * An unsigned integer indicating the season number this special episode airs before.
	 * Should be used in conjunction with airsbefore_episode for exact placement.
	 * This field is only available for special episodes. Can be null.
	 */
	@Element(required=false) int airsbefore_season

	/**
	 * A string which should be appended to &lt;mirrorpath&gt;/banners/ to determine the actual
	 * location of the artwork. Returns the location of the episode image. Can be null.
	 */
	@Element(required=false) String filename

	/**
	 * Unix time stamp indicating the last time any changes were made to the episode.
	 * Can be null.
	 */
	@Element(required=false) long lastupdated

	/**
	 * An unsigned integer assigned by our site to the season. Cannot be null.
	 */
	@Element int seasonid

	/**
	 * An unsigned integer assigned by our site to the series. It does not change and will
	 * always represent the same series. Cannot be null.
	 */
	@Element int seriesid

	/**
	 * A string containing the time the episode image was added to our site in the
	 * format "YYYY-MM-DD HH:MM:SS" based on a 24 hour clock. Can be null.
	 */
	@Element(required=false) String thumb_added

	/**
	 * An unsigned integer that represents the height of the episode image in pixels.
	 * Can be null
	 */
	@Element(required=false) int thumb_height

	/**
	 * An unsigned integer that represents the width of the episode image in pixels.
	 * Can be null
	 */
	@Element(required=false) int thumb_width
}
