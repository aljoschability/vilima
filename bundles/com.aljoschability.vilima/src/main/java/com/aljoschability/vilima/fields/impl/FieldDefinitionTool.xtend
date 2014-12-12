package com.aljoschability.vilima.fields.impl

import org.eclipse.core.runtime.IConfigurationElement
import com.aljoschability.vilima.fields.FieldProvider

interface FieldDefinitionTool {
	val FieldDefinitionTool INSTANCE = new FieldDefinitionToolImpl

	def String parseString(IConfigurationElement element, String name)

	def String parseString(IConfigurationElement element, String name, String standard)

	def boolean parseBoolean(IConfigurationElement element, String name)

	def int parseInteger(IConfigurationElement element, String name, int standard)

	def String readNamespace(IConfigurationElement element)

	def String readId(IConfigurationElement element)

	def String readName(IConfigurationElement element)

	def String readDescription(IConfigurationElement element)

	def String readImage(IConfigurationElement element)

	def String readCategoryId(IConfigurationElement element)

	def int readIndex(IConfigurationElement element)

	def int readWidth(IConfigurationElement element)

	def String readAlignment(IConfigurationElement element)

	def boolean readMonospaced(IConfigurationElement element)

	def FieldProvider readProvider(IConfigurationElement element)
}

class FieldDefinitionToolImpl implements FieldDefinitionTool {
	override parseString(IConfigurationElement element, String name) {
		parseString(element, name, null)
	}

	override parseString(IConfigurationElement element, String name, String standard) {
		element.getAttribute(name) ?: standard
	}

	override parseBoolean(IConfigurationElement element, String name) {
		Boolean::parseBoolean(element.getAttribute(name))
	}

	override parseInteger(IConfigurationElement element, String name, int standard) {
		try {
			return Integer::parseInt(element.getAttribute(name))
		} catch(NumberFormatException e) {
		}
		return standard
	}

	override readId(IConfigurationElement ce) { parseString(ce, "id") }

	override readName(IConfigurationElement ce) { parseString(ce, "name") }

	override readDescription(IConfigurationElement ce) { parseString(ce, "description") }

	override readImage(IConfigurationElement ce) { parseString(ce, "image") }

	override readIndex(IConfigurationElement ce) { parseInteger(ce, "index", -1) }

	override readWidth(IConfigurationElement ce) { parseInteger(ce, "width", 100) }

	override readAlignment(IConfigurationElement ce) { parseString(ce, "alignment", "LEAD") }

	override readNamespace(IConfigurationElement ce) { ce.contributor.name }

	override readCategoryId(IConfigurationElement ce) { parseString(ce, "category") }

	override readMonospaced(IConfigurationElement ce) { parseBoolean(ce, "monospaced") }

	override readProvider(IConfigurationElement ce) {
		try {
			val object = ce.createExecutableExtension("class")
			if(object instanceof FieldProvider) {
				return object
			}
		} catch(Exception e) {
		}
	}

}
