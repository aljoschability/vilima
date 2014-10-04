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
		content.files.clear

		refresh()
	}

	override add(MkvFile file) {
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

	def private void report(MkvFile file) {
		println(file.fileName)
		for (tag : file.tags) {
			println('''Tag: «tag.typeValue»:«tag.type»''')
			for (entry : tag.entries) {
				report(entry)
			}
		}
	}

	def private void report(MkvTagEntry entry) {
		println('''«entry.name»=«entry.string»«IF (entry.language != null)» [«entry.language»]«ENDIF»''')
		for (child : entry.entries) {
			report(child)
		}
	}

	override getContent() {
		return content
	}
}
