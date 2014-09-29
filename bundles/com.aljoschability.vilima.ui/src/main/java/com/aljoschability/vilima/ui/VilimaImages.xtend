package com.aljoschability.vilima.ui

final class MalimarImages {
	public static val FILE = "icons/file.png"

	public static val FLAG_UNDEFINED = "icons/flags/undefined.png"
	public static val FLAG_EN = "icons/flags/en.png"
	public static val FLAG_DE = "icons/flags/de.png"

	public static val TRACK_VIDEO = "icons/track/video.png"
	public static val TRACK_AUDIO = "icons/track/audio.png"
	public static val TRACK_TEXT = "icons/track/text.png"

	def static image(String key) {
		Activator::get.getImage(key)
	}

	def static descriptor(String key) {
		Activator::get.getImageDescriptor(key)
	}
}
