package com.aljoschability.vilima.rcp

import com.aljoschability.core.runtime.AbstractCoreActivator
import com.aljoschability.core.runtime.ICoreActivator

final class Activator extends AbstractCoreActivator {
	static ICoreActivator INSTANCE

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
