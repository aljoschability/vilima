package com.aljoschability.vilima.emf

import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import com.aljoschability.vilima.reading.MkFileReader

class MkResource extends ResourceImpl {
	MkFileReader reader = new MkFileReader

	new(URI uri) {
		super(uri)
	}

	override load(Map<?, ?> options) {
		if(!isLoaded) {
			val notification = setLoaded(true)

			isLoading = true

			errors?.clear()
			warnings?.clear()

			try {
				val result = reader.read(URIConverter.normalize(uri))

				getContents().add(result)
			} finally {
				isLoading = false
				notification?.eNotify
				modified = false

				timeStamp = System::currentTimeMillis
			}
		}
	}

	override save(Map<?, ?> options) {
		errors?.clear()
		warnings?.clear()

		println('''save the file «uri»''')

		modified = false
	}
}
