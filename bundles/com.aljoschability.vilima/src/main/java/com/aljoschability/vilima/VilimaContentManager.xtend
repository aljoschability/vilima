package com.aljoschability.vilima

import org.eclipse.e4.core.services.events.IEventBroker
import org.eclipse.emf.ecore.util.EcoreUtil
import com.aljoschability.vilima.xtend.LogExtension

class VilimaContentManager implements IContentManager {
	extension LogExtension = new LogExtension(typeof(VilimaContentManager), Activator::get)

	IEventBroker broker

	XVilimaLibrary library

	@Deprecated String path

	new(IEventBroker broker) {
		this.broker = broker

		library = VilimaFactory::eINSTANCE.createXVilimaLibrary()
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
		debug("#getPath() does not function")
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
