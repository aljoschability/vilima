package com.aljoschability.vilima

import org.eclipse.e4.core.di.annotations.Creatable
import org.eclipse.e4.core.services.events.IEventBroker
import org.eclipse.emf.ecore.util.EcoreUtil

@Creatable
class VilimaContentManager implements IContentManager {
	IEventBroker broker

	VilimaContent content

	new(IEventBroker broker) {
		this.broker = broker

		content = VilimaFactory::eINSTANCE.createVilimaContent
	}

	override clear() {
		for (file : content.files) {
			EcoreUtil::delete(file)
		}

		content.files.clear

		refresh()
	}

	override add(VilimaFile file) {
		content.files += file
	}

	override refresh() {
		broker.send(VilimaEventTopics::CONTENT_REFRESH, content)
	}

	override getPath() {
		return content.path
	}

	override setPath(String path) {
		content.path = path
	}

	override getContent() {
		return content
	}
}
