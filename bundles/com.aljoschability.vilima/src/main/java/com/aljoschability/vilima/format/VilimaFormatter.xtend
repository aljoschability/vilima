package com.aljoschability.vilima.format

import com.aljoschability.vilima.MkvTrack
import java.text.NumberFormat
import java.text.SimpleDateFormat

class VilimaFormatter {
	static val DATE_FORMATTER = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss")

	static val SIZE_FORMAT = NumberFormat::getNumberInstance

	def static String getTrackInfo(MkvTrack track) {
		if (track.codecId.startsWith("A_")) {
			return '''«track.codecId.substring(2)» («track.audioChannels» channels)'''
		}

		if (track.codecId.startsWith("S_")) {
			return track.codecId.substring(2)
		}

		if (track.codecId.startsWith("V_")) {
			if (track.codecId == "V_MS/VFW/FOURCC") {
				return '''«track.codecId.substring(2)» («track.codecPrivate»)'''
			}
			return track.codecId.substring(2)
		}

		return track.toString()
	}

	def static String fileSize(long size) {
		SIZE_FORMAT.maximumFractionDigits = 2

		var i = 1
		var result = size as double
		while (result > 1024) {
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

	def static String date(long timestamp) {
		return DATE_FORMATTER.format(timestamp)
	}

	def static String getTime(long duration) {
		if (duration >= 0) {
			val ms = duration % 1000
			val seconds = (duration / 1000) % 60;
			val minutes = ((duration / (1000 * 60)) % 60);
			val hours = ((duration / (1000 * 60 * 60)) % 24);

			val format = "%d:%02d:%02d,%03d"

			return String.format(format, hours, minutes, seconds, ms)
		}

		return ""
	}

	def static String getLanguage(String code) {
		if (code == null || code == "eng") {
			return '''English («code»)'''
		}

		if (code == "und") {
			return '''? («code»)'''
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
