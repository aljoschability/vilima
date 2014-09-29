package com.aljoschability.vilima

import com.aljoschability.core.runtime.AbstractCoreActivator

final class Activator extends AbstractCoreActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {
		Activator::INSTANCE = this

	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
