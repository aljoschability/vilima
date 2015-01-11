package com.aljoschability.vilima.ui.providers

import com.aljoschability.vilima.ui.Activator
import org.eclipse.jface.viewers.LabelProvider

class VilimaCatalogTreeLabelProvider extends LabelProvider {

	override getImage(Object element) {
		debug("we need an adapter factory!")
		return super.getImage(element)
	}

	override getText(Object element) {
		if(element instanceof VilimaCatalogTreeNode) {
			return element.name
		}

		debug("we need an adapter factory!")
		return super.getText(element)
	}

	private def void debug(String message) {
		Activator::get.debug('''[VilimaCatalogTreeLabelProvider] «message»''')
	}
}
