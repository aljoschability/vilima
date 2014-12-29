package com.aljoschability.vilima.ui.util

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider

class DataAllPartContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		return getChildren(element)
	}

	override getChildren(Object element) {
		if(element instanceof MkFile) {
			return element.tags
		}

		if(element instanceof MkTag) {
			return element.nodes
		}

		if(element instanceof MkTagNode) {
			return element.nodes
		}

		return newArrayOfSize(0)
	}

	override getParent(Object element) {
		return null
	}

	override hasChildren(Object element) {
		return !element.children.empty
	}
}
