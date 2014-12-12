package com.aljoschability.vilima.fields.impl

import com.aljoschability.vilima.fields.FieldDefinitionCategory
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @EqualsHashCode @ToString
class FieldDefinitionCategoryImpl implements FieldDefinitionCategory {
	String id
	String name
	String description
	String imageBundle
	String imagePath
	int index

	def boolean validate() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
