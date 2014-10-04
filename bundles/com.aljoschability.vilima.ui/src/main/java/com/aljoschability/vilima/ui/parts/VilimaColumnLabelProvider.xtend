package com.aljoschability.vilima.ui.parts

import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EObject

class VilimaColumnLabelProvider extends ColumnLabelProvider {
	val EStructuralFeature feature

	new(EStructuralFeature feature) {
		this.feature = feature
	}

	override getText(Object element) {
		if (element instanceof EObject) {
			return String.valueOf(element.eGet(feature))
		}

		return super.getText(element)
	}
}
