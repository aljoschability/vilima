package com.aljoschability.vilima

import org.eclipse.e4.core.services.events.IEventBroker
import org.eclipse.emf.ecore.util.EcoreUtil

class VilimaContentManager implements IContentManager {
	IEventBroker broker

	VilimaLibrary library

	@Deprecated String path

	new(IEventBroker broker) {
		this.broker = broker

		library = VilimaFactory::eINSTANCE.createVilimaLibrary()
	}

	override clear() {
		val delete = newHashSet()
		delete.addAll(content.files)

		content.files.clear

		for (file : delete) {
			EcoreUtil::delete(file)
		}

		refresh()
	}

	override add(MkFile file) {
		content.files += file
	}

	override refresh() {
		broker.send(VilimaEventTopics::CONTENT_REFRESH, content)
	}

	override getPath() {
		println("VilimaContentManager#getPath() does not function")
		return path
	}

	override setPath(String path) {
		this.path = path
	}

	override getContent() {
		return library
	}

	override getLibrary() {
		return library
	}
}
