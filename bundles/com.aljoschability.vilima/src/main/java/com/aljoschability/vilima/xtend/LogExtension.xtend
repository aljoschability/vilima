package com.aljoschability.vilima.xtend

import com.aljoschability.vilima.runtime.LoggingBundleActivator

class LogExtension {
	val LoggingBundleActivator activator
	val String prefix

	new(Class<?> clazz, LoggingBundleActivator activator) {
		this.activator = activator
		this.prefix = clazz.simpleName
	}

	def void debug(String message) {
		activator.debug('''[«prefix»] «message»''')
	}
}
