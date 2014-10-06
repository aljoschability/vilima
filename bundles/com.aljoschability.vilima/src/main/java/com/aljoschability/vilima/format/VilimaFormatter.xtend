package com.aljoschability.vilima.format

import java.text.NumberFormat
import java.text.SimpleDateFormat

class VilimaFormatter {
	static final VilimaFormatter formatter = new VilimaFormatter

	val SimpleDateFormat dateFormat
	val NumberFormat sizeFormat

	// hide constructor
	private new() {
		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss")

		sizeFormat = NumberFormat::getNumberInstance
		sizeFormat.maximumFractionDigits = 2

	}

	def static String fileSize(long size) {
		return formatter.getFileSize(size)
	}

	def static String date(long timestamp) {
		return formatter.getDate(timestamp)
	}

	def private getDate(long timestamp) {
		return dateFormat.format(timestamp)
	}

	def private getFileSize(long size) {
		var i = 1
		var result = size as double
		while (result > 1024) {
			result = result / 1024d
			i++
		}

		val unit = switch (i) {
			case 2: "kB"
			case 3: "MB"
			case 4: "GB"
			default: "Bytes"
		}

		return sizeFormat.format(result) + " " + unit
	}
}
