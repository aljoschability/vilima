package com.aljoschability.vilima.ui.providers

import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.emf.edit.provider.ComposedAdapterFactory
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import com.aljoschability.vilima.ui.providers.VilimaCatalogTreeNode

class VilimaCatalogTreeLabelProvider extends LabelProvider {
	val ComposedAdapterFactory adapterFactory
	val AdapterFactoryLabelProvider adapterFactoryLabelProvider

	new() {
		adapterFactory = new ComposedAdapterFactory(ComposedAdapterFactory.Descriptor.Registry::INSTANCE)
		adapterFactoryLabelProvider = new AdapterFactoryLabelProvider(adapterFactory)
	}

	override getImage(Object element) {
		return adapterFactoryLabelProvider.getImage(element)
	}

	override getText(Object element) {
		if (element instanceof VilimaCatalogTreeNode) {
			return element.name
		}

		return adapterFactoryLabelProvider.getText(element)
	}

	override dispose() {
		adapterFactoryLabelProvider.dispose()
		adapterFactory.dispose()
		super.dispose()
	}
}
