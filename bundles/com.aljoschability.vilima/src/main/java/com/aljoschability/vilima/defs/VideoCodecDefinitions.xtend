package com.aljoschability.vilima.defs

import com.aljoschability.vilima.VideoCodec
import com.aljoschability.vilima.VilimaFactory
import java.util.Collection

class VideoCodecDefinitions {
	val static Collection<VideoCodec> list = newArrayList

	private static def void init() {
		list += create("V_MS/VFW/FOURCC", "XVid")
	}

	static def create(String id, String name) {
		val codec = VilimaFactory::eINSTANCE.createVideoCodec

		codec.id = id
		codec.name = name

		return codec
	}

	def Collection<VideoCodec> get() {
		if (list.empty) {
			init()
		}

		return list
	}

	private new() {
	}
}
