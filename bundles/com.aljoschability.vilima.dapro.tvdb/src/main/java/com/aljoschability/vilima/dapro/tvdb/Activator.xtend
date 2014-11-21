package com.aljoschability.vilima.dapro.tvdb

import com.aljoschability.core.ui.runtime.AbstractActivator
import com.aljoschability.core.ui.runtime.IActivator

class Activator extends AbstractActivator {
	static IActivator INSTANCE

	override protected initialize() {
		Activator::INSTANCE = this
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
