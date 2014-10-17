package com.aljoschability.vilima.dapro.tmdb

import com.aljoschability.core.runtime.AbstractCoreActivator
import com.aljoschability.core.runtime.ICoreActivator

class Activator extends AbstractCoreActivator {
	static ICoreActivator INSTANCE

	override protected initialize() {
		Activator::INSTANCE = this
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
