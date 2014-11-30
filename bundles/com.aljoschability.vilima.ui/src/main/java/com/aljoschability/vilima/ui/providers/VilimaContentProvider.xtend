package com.aljoschability.vilima.ui.providers

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.XVilimaLibrary
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider

class VilimaContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	IContentManager manager

	override getElements(Object element) {
		if(element instanceof XVilimaLibrary) {
			return element.files
		}

		return super.getElements(element)
	}

	new(IContentManager manager) {
		this.manager = manager
	}

	override getChildren(Object element) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getParent(Object element) {
		return null
	}

	override hasChildren(Object element) {
		return false
	}
}
