package com.aljoschability.vilima.ui.services

import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Display

interface ImageService {
	val IMG_TRACK_VIDEO = "icons/model/track/video.png"
	val IMG_TRACK_AUDIO = "icons/model/track/audio.png"
	val IMG_TRACK_SUBTITLE = "icons/model/track/subtitle.png"

	val ARROW_DOWN = "icons/entypo/arrow-down.png"
	val ARROW_LEFT = "icons/entypo/arrow-left.png"
	val ARROW_RIGHT = "icons/entypo/arrow-right.png"
	val ARROW_UP = "icons/entypo/arrow-up.png"

	val TRIANGLE_DOWN = "icons/entypo/triangle-down.png"
	val TRIANGLE_LEFT = "icons/entypo/triangle-left.png"
	val TRIANGLE_RIGHT = "icons/entypo/triangle-right.png"
	val TRIANGLE_UP = "icons/entypo/triangle-up.png"

	def Image getImage(Display display, String path)
}
