package com.aljoschability.vilima.ui

final class VilimaImages {
	public static val TRACK_TYPE_VIDEO = "icons/data/tracktypes/video.png"
	public static val TRACK_TYPE_AUDIO = "icons/data/tracktypes/audio.png"
	public static val TRACK_TYPE_SUBTITLE = "icons/data/tracktypes/subtitle.png"

	public static val ARROW_DOWN = "icons/entypo/arrow-down.png"
	public static val ARROW_LEFT = "icons/entypo/arrow-left.png"
	public static val ARROW_RIGHT = "icons/entypo/arrow-right.png"
	public static val ARROW_UP = "icons/entypo/arrow-up.png"

	public static val TRIANGLE_DOWN = "icons/entypo/triangle-down.png"
	public static val TRIANGLE_LEFT = "icons/entypo/triangle-left.png"
	public static val TRIANGLE_RIGHT = "icons/entypo/triangle-right.png"
	public static val TRIANGLE_UP = "icons/entypo/triangle-up.png"

	def static image(String key) {
		Activator::get.getImage(key)
	}

	def static descriptor(String key) {
		Activator::get.getImageDescriptor(key)
	}
}
