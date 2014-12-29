package com.aljoschability.vilima

import org.eclipse.emf.transaction.TransactionalEditingDomain
import org.eclipse.emf.common.command.CommandStack

interface VilimaManager {
	def TransactionalEditingDomain getEditingDomain()

	def CommandStack getCommandStack()
}

class VilimaManagerImpl implements VilimaManager {
	val TransactionalEditingDomain editingDomain

	new() {
		editingDomain = TransactionalEditingDomain::Factory::INSTANCE.createEditingDomain
	}

	override getEditingDomain() { editingDomain }

	override getCommandStack() { editingDomain.commandStack }
}

interface VilimaManagerProvider {
	def VilimaManager getVilimaManager()
}
