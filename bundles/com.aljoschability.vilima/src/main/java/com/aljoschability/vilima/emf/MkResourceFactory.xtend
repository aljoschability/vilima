package com.aljoschability.vilima.emf

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl

class MkResourceFactory extends ResourceFactoryImpl {
	override createResource(URI uri) { new MkResource(uri) }
}
