package com.aljoschability.vilima.ui.providers

import java.util.Collection

class VilimaCatalogTreeNode {
	val String name
	val Collection<?> collection

	new(String name, Collection<?> collection) {
		this.name = name
		this.collection = collection
	}

	def String getName() {
		return name
	}

	def Collection<?> getChildren() {
		return collection
	}
}
