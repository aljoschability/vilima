package com.aljoschability.vilima.ui.providers

import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider

class ListTreeContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getChildren(Object element) {
		element.elements
	}

	override getParent(Object element) {
		null
	}

	override hasChildren(Object element) {
		false
	}
}
