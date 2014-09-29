package com.aljoschability.vilima.ui.providers

import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider
import com.aljoschability.vilima.IContentManager

class VilimaContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	IContentManager manager

	new(IContentManager manager) {
		this.manager = manager
	}

	override getChildren(Object parentElement) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getParent(Object element) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override hasChildren(Object element) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
