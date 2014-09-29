package com.aljoschability.vilima.defs

import com.aljoschability.vilima.SubtitleCodec
import com.aljoschability.vilima.VilimaFactory
import java.util.Collection

class SubtitleCodecDefinitions {
	val static Collection<SubtitleCodec> list = newArrayList

	private static def void init() {
		list += create("S_TEXT/UTF8", "Plain")
		list += create("S_TEXT/SSA", "Subtitles Format")
		list += create("S_TEXT/ASS", "Advanced Subtitles Format")
		list += create("S_TEXT/USF", "Universal Subtitle Format")
		list += create("S_IMAGE/BMP", "Bitmap Based Subtitle Format")
		list += create("S_VOBSUB", "VobSub")
		list += create("S_KATE", "Karaoke And Text Encapsulation")
	}

	static def create(String id, String name) {
		val codec = VilimaFactory::eINSTANCE.createSubtitleCodec

		codec.id = id
		codec.name = name

		return codec
	}

	def Collection<SubtitleCodec> get() {
		if (list.empty) {
			init()
		}

		return list
	}

	private new() {
	}
}
