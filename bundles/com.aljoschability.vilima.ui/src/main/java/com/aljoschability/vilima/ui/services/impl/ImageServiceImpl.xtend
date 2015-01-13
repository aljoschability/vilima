package com.aljoschability.vilima.ui.services.impl

import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.services.ImageService
import com.aljoschability.vilima.xtend.LogExtension
import java.util.Map
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Path
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Display
import org.osgi.framework.BundleContext

class ImageServiceImpl implements ImageService {
	extension LogExtension = new LogExtension(typeof(ImageServiceImpl), Activator::get)

	val Map<Display, Map<String, Image>> cache = newLinkedHashMap

	val BundleContext context

	new(BundleContext context) {
		this.context = context
	}

	override getImage(Display display, String path) {
		var cacheImages = cache.get(display)
		if(cacheImages == null) {
			cacheImages = newLinkedHashMap
			cache.put(display, cacheImages)
		}

		var image = cacheImages.get(path)
		if(image == null) {
			val url = FileLocator::find(context.bundle, new Path(path), null)
			if(url != null) {
				val stream = url.openStream

				image = new Image(display, stream)

				stream.close

				cacheImages.put(path, image)
			}
		}

		return image
	}

	override getImage(Display display, MkTrackType element) {
		val path = switch element {
			case VIDEO: MODEL_TRACK_TYPE_VIDEO
			case AUDIO: MODEL_TRACK_TYPE_AUDIO
			case SUBTITLE: MODEL_TRACK_TYPE_SUBTITLE
			default: null
		}

		if(path == null) {
			Activator::get.warn('''There is no image for this track type.''')
			return null
		}

		return getImage(display, path)
	}

	override start() {
		debug("The image service has been started.")
	}

	override stop() {
		debug("The image service has been stopped.")
	}
}
