package com.aljoschability.vilima.fields.impl

import com.aljoschability.vilima.fields.FieldParameterLiteral
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @ToString @EqualsHashCode
class FieldParameterLiteralImpl implements FieldParameterLiteral {
	val static ATTRIBUTE_NAME = "name"
	val static ATTRIBUTE_TITLE = "title"

	val String name
	val String title

	def static FieldParameterLiteral create(IConfigurationElement lce) {
		val name = lce.getAttribute(ATTRIBUTE_NAME)
		val title = lce.getAttribute(ATTRIBUTE_TITLE)

		if(name != null && title != null) {
			return new FieldParameterLiteralImpl(name, title)
		}
	}
}
