package com.aljoschability.vilima.fields

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.IConfigurationElement
import java.util.Map
import com.aljoschability.vilima.fields.impl.FieldDefinitionTool
import com.aljoschability.vilima.Activator
import com.aljoschability.vilima.fields.impl.FieldDefinitionImpl
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import com.aljoschability.vilima.fields.impl.FieldDefinitionCategoryImpl

interface FieldRegistry {
	def List<FieldDefinitionCategory> getAllCategories()
}

class FieldRegistryImpl implements FieldRegistry {
	val static ID = "com.aljoschability.vilima.fields"

	extension FieldDefinitionTool = FieldDefinitionTool::INSTANCE

	val List<FieldDefinitionCategory> categoryList

	new() {
		val Map<String, FieldDefinitionCategoryImpl> categories = newLinkedHashMap
		val Map<String, FieldDefinitionImpl> fields = newLinkedHashMap

		// cache all valid registered extension elements
		val elements = Platform::getExtensionRegistry.getConfigurationElementsFor(ID)
		for (element : elements) {
			switch (element.name) {
				case "category": {
					val category = newCategory[
						id = element.readId
						name = element.readName
						description = element.readDescription
						imageBundle = element.readNamespace
						imagePath = element.readImage
						index = element.readIndex
					]

					// validate
					if(categories.containsKey(category.id)) {
						val message = '''The category was already defined and will be overridden.'''
						Activator::get.warn(message)
					} else if(category.validate) {
						categories.put(category.id, category)
					}
				}
				case "field": {
					val field = newField[
						id = element.readId
						name = element.readName
						description = element.readDescription
						categoryId = element.readCategoryId
						index = element.readIndex
						defaultWidth = element.readWidth
						defaultAlignment = element.readAlignment
						defaultMonospace = element.readMonospaced
						provider = element.readProvider
					]

					// validate
					if(fields.containsKey(field.id)) {
						val message = '''The field was already defined and will be ignored.'''
						Activator::get.warn(message)
					} else if(field.validate) {
						fields.put(field.id, field)
					}
				}
			}
		}

		// weave categories and fields
		categoryList = categories.values.sortWith[a, b|Integer.compare(a.index, b.index)].immutableCopy
	}

	def private static FieldDefinitionImpl newField(Procedure1<FieldDefinitionImpl> field) {
		return new FieldDefinitionImpl
	}

	def private static FieldDefinitionCategoryImpl newCategory(Procedure1<FieldDefinitionCategoryImpl> category) {
		return new FieldDefinitionCategoryImpl
	}

	override getAllCategories() {
		return categoryList
	}
}
