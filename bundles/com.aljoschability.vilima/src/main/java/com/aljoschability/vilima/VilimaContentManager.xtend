package com.aljoschability.vilima

import org.eclipse.e4.core.di.annotations.Creatable
import org.eclipse.e4.core.services.events.IEventBroker

@Creatable
class VilimaContentManager implements IContentManager {
	IEventBroker broker

	VilimaContent content

	new(IEventBroker broker) {
		this.broker = broker

		content = VilimaFactory::eINSTANCE.createVilimaContent
	}

	override clear() {
		broker.send(VilimaEventTopics::CONTENT_CLEAR, null)
		content.files.clear
	}

	override getPath() {
		return content.path
	}

	override setPath(String path) {
		content.path = path
	}

	override add(MkvFile file) {
		content.files += file

		println(file)

		broker.post(VilimaEventTopics::CONTENT_ADD, file)
	}

	override getContent() {
		return content
	}
}
