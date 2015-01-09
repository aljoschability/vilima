package com.aljoschability.vilima.rcp

import com.aljoschability.vilima.runtime.AbstractLoggingBundleActivator
import com.aljoschability.vilima.runtime.LoggingBundleActivator

final class Activator extends AbstractLoggingBundleActivator {
	static LoggingBundleActivator INSTANCE

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
