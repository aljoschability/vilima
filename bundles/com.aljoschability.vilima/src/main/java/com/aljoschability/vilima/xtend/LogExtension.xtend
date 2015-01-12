package com.aljoschability.vilima.xtend

import com.aljoschability.vilima.runtime.LoggingBundleActivator

class LogExtension {
	val LoggingBundleActivator activator
	val String prefix

	new(String prefix, LoggingBundleActivator activator) {
		this.activator = activator
		this.prefix = prefix
	}

	def void debug(String message) {
		activator.debug('''[«prefix»] «message»''')
	}
}
