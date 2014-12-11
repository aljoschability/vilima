package com.aljoschability.vilima.fields.impl

import com.aljoschability.vilima.fields.FieldParameter
import com.aljoschability.vilima.fields.FieldParameterLiteral
import com.aljoschability.vilima.fields.FieldParameterType
import com.aljoschability.vilima.fields.FieldParameterValidator
import java.util.Map
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @ToString @EqualsHashCode
class FieldParameterImpl implements FieldParameter {
	val static ELEMENT_LITERAL = "literal"

	val static ATTRIBUTE_NAME = "name"
	val static ATTRIBUTE_TITLE = "title"
	val static ATTRIBUTE_TYPE = "type"
	val static ATTRIBUTE_DEFAULT_VALUE = "default_value"
	val static ATTRIBUTE_DESCRIPTION = "description"
	val static ATTRIBUTE_VALIDATOR = "validator"

	val static VALUE_TYPE_BOOLEAN = "Boolean"
	val static VALUE_TYPE_ENUMERATION = "Enumeration"
	val static VALUE_TYPE_INTEGER = "Integer"
	val static VALUE_TYPE_DECIMAL = "Decimal"
	val static VALUE_TYPE_STRING = "String"

	val String name
	val String title
	val FieldParameterType type
	val String defaultValue
	val String description
	val FieldParameterValidator validator
	val Map<Integer, FieldParameterLiteral> literals

	def static FieldParameter create(IConfigurationElement pce) {
		val name = pce.getAttribute(ATTRIBUTE_NAME)
		val title = pce.getAttribute(ATTRIBUTE_TITLE)
		val type = readType(pce)
		val defaultValue = pce.getAttribute(ATTRIBUTE_DEFAULT_VALUE)
		val description = pce.getAttribute(ATTRIBUTE_DESCRIPTION)
		val validator = readValidator(pce)

		// all basic required values given
		if(name != null && title != null && type != null) {

			// read literals
			var Map<Integer, FieldParameterLiteral> literalsMap = null
			if(FieldParameterType::ENUMERATION == type) {
				literalsMap = newLinkedHashMap

				var literalIndex = 0
				for (lce : pce.getChildren(ELEMENT_LITERAL)) {
					val literal = FieldParameterLiteralImpl::create(lce)
					if(literal != null) {
						literalsMap.put(literalIndex, literal)
						literalIndex++
					}
				}
				literalsMap = literalsMap.immutableCopy
			}

			return new FieldParameterImpl(name, title, type, defaultValue, description, validator, literalsMap)
		}
	}

	def private static FieldParameterValidator readValidator(IConfigurationElement ce) {
		val object = ce.createExecutableExtension(ATTRIBUTE_VALIDATOR)
		if(object instanceof FieldParameterValidator) {
			return object
		}
		return null
	}

	def private static FieldParameterType readType(IConfigurationElement ce) {
		val value = ce.getAttribute(ATTRIBUTE_TYPE)
		if(value != null) {
			switch value {
				case VALUE_TYPE_BOOLEAN: return FieldParameterType::BOOLEAN
				case VALUE_TYPE_ENUMERATION: return FieldParameterType::ENUMERATION
				case VALUE_TYPE_INTEGER: return FieldParameterType::INTEGER
				case VALUE_TYPE_DECIMAL: return FieldParameterType::DECIMAL
				case VALUE_TYPE_STRING: return FieldParameterType::STRING
			}
		}
	}
}
