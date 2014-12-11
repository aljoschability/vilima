package com.aljoschability.vilima.fields

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

interface FieldCategory extends Comparable<FieldCategory> {
	def String getName()

	def String getTitle()

	def int getIndex()
}

@Accessors @EqualsHashCode @ToString
class FieldCategoryImpl implements FieldCategory {
	val String name
	val String title
	val int index

	override compareTo(FieldCategory o) {
		if(o != null) {
			return Integer.compare(this.index, o.index)
		}
		return -1
	}
}
