package com.aljoschability.vilima.emf

import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import com.aljoschability.vilima.reading.MkFileReader
import com.aljoschability.vilima.MkFile

class MkResource extends ResourceImpl {
	val MkFileReader reader = new MkFileReader

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
				getContents() += reader.read(URIConverter.normalize(uri))
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

		val file = getContents().get(0) as MkFile

		println('''save the file «uri» with content «file»''')
		

		modified = false
	}
}
