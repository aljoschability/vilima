package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkTrack
import java.text.NumberFormat
import java.text.SimpleDateFormat

class VilimaFormatter {
	static val DATE_FORMATTER = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss")

	static val SIZE_FORMAT = NumberFormat::getNumberInstance

	static val SIZE_BYTES_FORMAT = NumberFormat::getIntegerInstance

	def static String getTrackInfo(MkTrack track) {
		if(track.getCodec.startsWith("A_")) {
			return '''«track.codec.substring(2)» («track.audioChannels ?: "?"» channels)'''
		}

		if(track.getCodec.startsWith("S_")) {
			return track.getCodec.substring(2)
		}

		if(track.getCodec.startsWith("V_")) {
			return track.getCodec.substring(2)
		}

		return track.toString()
	}

	def static String fileSize(Long size) {
		if(size == null) {
			return null
		}

		SIZE_FORMAT.minimumFractionDigits = 2
		SIZE_FORMAT.maximumFractionDigits = 2

		var i = 1
		var result = size as double
		while(result > 1024) {
			result /= 1024d
			i++
		}

		val unit = switch (i) {
			case 2: "kB"
			case 3: "MB"
			case 4: "GB"
			default: "Bytes"
		}

		return SIZE_FORMAT.format(result) + " " + unit
	}

	def static String fileSizeBytes(Long size) {
		if(size == null) {
			return null
		}

		return SIZE_BYTES_FORMAT.format(size) + " Bytes"
	}

	def static String date(Long timestamp) {
		if(timestamp == null) {
			return null
		}
		return DATE_FORMATTER.format(timestamp)
	}

	def static String getTime(Long duration) {
		getTime(duration, false)
	}

	def static String getTime(Long duration, boolean showMillis) {
		if(duration == null) {
			return ""
		}

		val ms = (duration % 1000) as int
		val seconds = ((duration / 1000) % 60) as int
		val minutes = ((duration / (1000 * 60)) % 60) as int
		val hours = ((duration / (1000 * 60 * 60)) % 24) as int

		val builder = new StringBuilder
		if(hours > 0) {
			builder.append(hours)
			builder.append(":")
		}

		//			if(builder.length > 0|| minutes > 0 ) {
		builder.append(String.format("%02d", minutes))
		builder.append(":")

		//			}
		if(builder.length > 0 || seconds > 0) {
			builder.append(String.format("%02d", seconds))
			if(showMillis) {
				builder.append(",")
			}
		}

		if(showMillis) {
			if(builder.length > 0 || ms > 0) {
				builder.append(String.format("%03d", ms))
			}
		}

		// val format = "%d:%02d:%02d,%03d"
		// return String.format(format, hours, minutes, seconds, ms)
		return builder.toString()
	}

	def static String getTimeSeconds(Long duration) {
		if(duration == null) {
			return ""
		}

		TIME_FORMAT_SEC.minimumFractionDigits = 0
		TIME_FORMAT_SEC.maximumFractionDigits = 0

		TIME_FORMAT_SEC.format(duration / 1000d) + " s"
	}

	def static String getTimeMinutes(Long duration) {
		if(duration == null) {
			return ""
		}

		TIME_FORMAT_MIN.minimumFractionDigits = 0
		TIME_FORMAT_MIN.maximumFractionDigits = 0

		TIME_FORMAT_MIN.format(duration / 60000d) + " min"
	}

	@Deprecated
	def static String getTime(Double duration) {
		getTime(duration, false)
	}

	val static TIME_FORMAT_SEC = NumberFormat::getIntegerInstance
	val static TIME_FORMAT_MIN = NumberFormat::getIntegerInstance

	@Deprecated
	def static String getTimeSeconds(Double duration) {
		if(duration == null) {
			return ""
		}

		TIME_FORMAT_SEC.minimumFractionDigits = 0
		TIME_FORMAT_SEC.maximumFractionDigits = 0

		TIME_FORMAT_SEC.format(duration / 1000d) + " s"
	}

	@Deprecated
	def static String getTimeMinutes(Double duration) {
		if(duration == null) {
			return ""
		}

		TIME_FORMAT_MIN.minimumFractionDigits = 0
		TIME_FORMAT_MIN.maximumFractionDigits = 0

		TIME_FORMAT_MIN.format(duration / 60000d) + " min"
	}

	@Deprecated
	def static String getTime(Double duration, boolean showMillis) {
		if(duration == null) {
			return ""
		}

		if(duration >= 0) {
			val ms = (duration % 1000) as int
			val seconds = ((duration / 1000) % 60) as int
			val minutes = ((duration / (1000 * 60)) % 60) as int
			val hours = ((duration / (1000 * 60 * 60)) % 24) as int

			val builder = new StringBuilder
			if(hours > 0) {
				builder.append(hours)
				builder.append(":")
			}

			//			if(builder.length > 0|| minutes > 0 ) {
			builder.append(String.format("%02d", minutes))
			builder.append(":")

			//			}
			if(builder.length > 0 || seconds > 0) {
				builder.append(String.format("%02d", seconds))
				if(showMillis) {
					builder.append(",")
				}
			}

			if(showMillis) {
				if(builder.length > 0 || ms > 0) {
					builder.append(String.format("%03d", ms))
				}
			}

			// val format = "%d:%02d:%02d,%03d"
			// return String.format(format, hours, minutes, seconds, ms)
			return builder.toString()
		}

		return ""
	}

	def static String getLanguage(String code) {
		if(code == null || code == "eng") {
			return '''English («code»)'''
		}

		if(code == "und") {
			return ""
		}

		switch (code) {
			case "fre":
				return '''Français («code»)'''
			case "ger":
				return '''Deutsch («code»)'''
			case "hun":
				return '''Magyar («code»)'''
			case "ita":
				return '''Italiano («code»)'''
			case "jpn":
				return '''日本の («code»)'''
			case "spa":
				return '''Español («code»)'''
			default: {
				println('''Language "«code»" not found. [«VilimaFormatter»]''')
				return code
			}
		}
	}
}
