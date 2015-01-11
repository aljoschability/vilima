package com.aljoschability.vilima.ui.services

import com.aljoschability.vilima.MkTrackType
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Display

interface ImageService {
	val MODEL_TRACK_TYPE_VIDEO = "icons/model/track/video.png"
	val MODEL_TRACK_TYPE_AUDIO = "icons/model/track/audio.png"
	val MODEL_TRACK_TYPE_SUBTITLE = "icons/model/track/subtitle.png"

	val ARROW_DOWN = "icons/entypo/arrow-down.png"
	val ARROW_LEFT = "icons/entypo/arrow-left.png"
	val ARROW_RIGHT = "icons/entypo/arrow-right.png"
	val ARROW_UP = "icons/entypo/arrow-up.png"

	val TRIANGLE_DOWN = "icons/entypo/triangle-down.png"
	val TRIANGLE_LEFT = "icons/entypo/triangle-left.png"
	val TRIANGLE_RIGHT = "icons/entypo/triangle-right.png"
	val TRIANGLE_UP = "icons/entypo/triangle-up.png"

	val STATE_INFO = "icons/entypo/triangle-up.png"
	val STATE_WARN = "icons/entypo/triangle-up.png"
	val STATE_ERROR = "icons/entypo/triangle-up.png"
	val STATE_QUESTION = "icons/entypo/triangle-up.png"

	val CONTROL_ADD = "icons/entypo/arrow-up.png"
	val CONTROL_REMOVE = "icons/entypo/arrow-up.png"

	def void start()

	def void stop()

	def Image getImage(Display display, String path)

	/**
	 * Delivers an appropriate image for the track type.
	 * 
	 * @return Returns an image for track type or <code>null</code> when none is available.
	 */
	def Image getImage(Display display, MkTrackType element)
}
