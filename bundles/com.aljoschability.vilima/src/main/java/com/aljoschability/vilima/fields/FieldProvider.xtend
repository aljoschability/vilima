package com.aljoschability.vilima.fields

import com.aljoschability.vilima.fields.impl.FieldParameterImpl
import java.util.Map
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

interface FieldProvider {
	def String getName()

	def String getTitle()

	def int getWidth()

	def int getAlignment()

	def boolean isMonospaced()

	def String getDescription()

	def Object getProvider()

	def Map<String, FieldParameter> getParameters()
}

@Accessors @EqualsHashCode @ToString
class FieldProviderImpl implements FieldProvider {
	val String name
	val String title
	val int width
	val int alignment
	val boolean monospaced
	val String description
	val Object provider
	val Map<String, FieldParameter> parameters

	def static FieldProvider create(IConfigurationElement fce) {
		val name = fce.readName

		// val category = fce.asString(ATTRIBUTE_CATEGORY)
		val title = fce.readTitle
		val width = fce.readWidth
		val alignment = fce.readAlignment
		val monospaced = fce.readMonospaced
		val description = fce.readDescription
		val Object provider = fce.readProvider

		// check required
		if(name != null && provider != null) {

			// collect parameters
			var Map<String, FieldParameter> parameters = newLinkedHashMap
			for (pce : fce.getChildren("parameter")) {
				val parameter = FieldParameterImpl::create(pce)
				if(parameter != null) {
					parameters.put(parameter.name, parameter)
				}
			}

			// create field provider
			return new FieldProviderImpl(name, title, width, alignment, monospaced, description, provider, parameters)
		}
	}

	def static private String readName(IConfigurationElement ce) {
		ce.getAttribute("name")
	}

	def static private String readTitle(IConfigurationElement ce) {
		ce.getAttribute("hint_title")
	}

	def static private int readWidth(IConfigurationElement ce) {
		ce.readInteger("hint_width", 100)
	}

	def static private int readAlignment(IConfigurationElement ce) {
		val value = ce.getAttribute("hint_alignment") ?: "LEAD"
		switch value {
			case "CENTER": return 1 << 24
			case "TRAIL": return 1 << 17
			default: return 1 << 14
		}
	}

	def static private boolean readMonospaced(IConfigurationElement ce) {
		return Boolean::parseBoolean(ce.getAttribute("hint_monospaced"))
	}

	def static private String readDescription(IConfigurationElement ce) {
		ce.getAttribute("description")
	}

	def static private int readInteger(IConfigurationElement ce, String name, int defaultValue) {
		try {
			return Integer::parseInt(ce.getAttribute(name))
		} catch(NumberFormatException e) {
			return defaultValue
		}
	}

	def static private Object readProvider(IConfigurationElement ce) {
		ce.getAttribute("class")
	}

}
