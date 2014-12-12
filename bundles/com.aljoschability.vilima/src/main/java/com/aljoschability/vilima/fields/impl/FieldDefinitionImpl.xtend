package com.aljoschability.vilima.fields.impl

import com.aljoschability.vilima.fields.FieldDefinition
import com.aljoschability.vilima.fields.FieldDefinitionCategory
import com.aljoschability.vilima.fields.FieldDefinitionParameter
import com.aljoschability.vilima.fields.FieldProvider
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors @EqualsHashCode @ToString
class FieldDefinitionImpl implements FieldDefinition {
	String id
	String name
	String description
	FieldDefinitionCategory category
	int defaultWidth
	String defaultAlignment
	boolean defaultMonospace
	FieldProvider provider
	Map<String, FieldDefinitionParameter> parameters
	
	// temp
	String categoryId
	int index
	
	def boolean validate() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
