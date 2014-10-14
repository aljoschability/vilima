package com.aljoschability.vilima.ui.providers

import com.aljoschability.vilima.VilimaLibrary
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider

class VilimaCatalogTreeContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		val list = newArrayList
		if (element instanceof VilimaLibrary) {
			list += new VilimaCatalogTreeNode("Genres", element.genres)
		}
		return list
	}

	override getChildren(Object element) {
		if (element instanceof VilimaCatalogTreeNode) {
			return element.children
		}
		return newArrayOfSize(0)
	}

	override getParent(Object element) {
		return null
	}

	override hasChildren(Object element) {
		return element.children.size > 0
	}
}
