package com.aljoschability.vilima.extensions

import org.eclipse.core.runtime.IConfigurationElement

interface ConfigurationElementExtension {
	val ConfigurationElementExtension INSTANCE = new ConfigurationElementExtensionImpl

	def String asString(IConfigurationElement element, String name)

	def Integer asInteger(IConfigurationElement element, String name)

	def Integer asInteger(IConfigurationElement element, String name, Integer defaultValue)
}

class ConfigurationElementExtensionImpl implements ConfigurationElementExtension {
	override asString(IConfigurationElement element, String name) {
		element.getAttribute(name)
	}

	override asInteger(IConfigurationElement element, String name) {
		element.asInteger(name, 0)
	}

	override asInteger(IConfigurationElement element, String name, Integer defaultValue) {
		try {
			Integer.parseInt(element.getAttribute(name))
		} catch(NumberFormatException e) {
			return defaultValue
		}
	}
}
