package com.aljoschability.vilima

import org.eclipse.emf.common.command.CommandStack
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.transaction.TransactionalEditingDomain

interface VilimaManager {
	def void addFile(String path)

	def ResourceSet getResourceSet()

	def TransactionalEditingDomain getEditingDomain()

	def CommandStack getCommandStack()
}

class VilimaManagerImpl implements VilimaManager {
	val TransactionalEditingDomain editingDomain

	new() {
		editingDomain = TransactionalEditingDomain.Factory::INSTANCE.createEditingDomain
	}

	override getResourceSet() { editingDomain.resourceSet }

	override getEditingDomain() { editingDomain }

	override getCommandStack() { editingDomain.commandStack }

	override addFile(String path) {
		resourceSet.getResource(URI::createFileURI(path), true)
	}
}
