package com.aljoschability.vilima.ui.services.impl

import com.aljoschability.vilima.ui.services.ImageService
import java.util.Map
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Path
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Display
import org.osgi.framework.BundleContext

class ImageServiceImpl implements ImageService {
	val Map<Display, Map<String, Image>> cache

	val BundleContext context

	new(BundleContext context) {
		cache = newLinkedHashMap

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
}
