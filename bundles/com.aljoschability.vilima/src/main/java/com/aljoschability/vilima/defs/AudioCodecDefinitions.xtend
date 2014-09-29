package com.aljoschability.vilima.defs

import com.aljoschability.vilima.AudioCodec
import com.aljoschability.vilima.VilimaFactory
import java.util.Collection

class AudioCodecDefinitions {
	val static Collection<AudioCodec> list = newArrayList

	private static def void init() {
		list += create("A_AAC", "AAC Profile Audio")
		list += create("A_AC3", "AC3")
		list += create("A_DTS", "Digital Theatre System")
		list += create("A_MPEG/L2", "MP2")
		list += create("A_MPEG/L3", "MP3")
		list += create("A_VORBIS", "Vorbis")
	}

	static def create(String id, String name) {
		val codec = VilimaFactory::eINSTANCE.createAudioCodec

		codec.id = id
		codec.name = name

		return codec
	}

	static def Collection<AudioCodec> get() {
		if (list.empty) {
			init()
		}

		return list
	}

	private new() {
	}
}
