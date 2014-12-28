package com.aljoschability.vilima.ui.widgets

import com.aljoschability.vilima.MkTrack
import java.math.BigInteger

class MkTrackNameWidget extends BaseTextWidget<MkTrack> {
	new() {
		super("Name", "The name of the track.")
	}

	override protected getValue(MkTrack element) { element?.name }

	override protected setValue(MkTrack element, String value) {
		if(element == null) {
			return
		}
		element.name = value
	}
}

class MkTrackUidWidget extends BaseTextWidget<MkTrack> {
	new() {
		super("UID", "The unique identifier of the track as unsigned integer.")
	}

	override protected getValue(MkTrack element) {
		if(element == null) {
			return null
		}

		val value = element.uid
		if(value < 0) {
			return BigInteger::valueOf(value).toString
		}
		return value.toString
	}

	override protected setValue(MkTrack element, String value) {
		if(element == null) {
			return
		}
		if(value.nullOrEmpty) {
			element.uid = null
		} else {
			try {
				element.uid = Long::parseLong(value)
			} catch(NumberFormatException e) {
				println('''could not parse value into long.''')
			}
		}
	}
}
