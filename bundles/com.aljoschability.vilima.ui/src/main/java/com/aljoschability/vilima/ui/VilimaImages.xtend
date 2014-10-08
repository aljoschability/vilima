package com.aljoschability.vilima.ui

final class VilimaImages {
	public static val TRACK_TYPE_VIDEO = "icons/data/tracktypes/video.png"
	public static val TRACK_TYPE_AUDIO = "icons/data/tracktypes/audio.png"
	public static val TRACK_TYPE_SUBTITLE = "icons/data/tracktypes/subtitle.png"

	def static image(String key) {
		Activator::get.getImage(key)
	}

	def static descriptor(String key) {
		Activator::get.getImageDescriptor(key)
	}
}
