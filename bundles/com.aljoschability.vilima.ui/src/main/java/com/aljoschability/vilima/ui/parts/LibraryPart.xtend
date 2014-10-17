package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaLibrary
import com.aljoschability.vilima.ui.providers.VilimaLibraryTreeContentProvider
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.emf.edit.provider.ComposedAdapterFactory
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree

class LibraryPart {
	VilimaLibrary library

	TreeViewer viewer

	@PostConstruct
	def postConstruct(Composite parent) {
		val tree = new Tree(parent, SWT::MULTI)

		viewer = new TreeViewer(tree)

		val af = new ComposedAdapterFactory(ComposedAdapterFactory.Descriptor.Registry::INSTANCE)
		viewer.labelProvider = new AdapterFactoryLabelProvider(af)
		viewer.contentProvider = new VilimaLibraryTreeContentProvider()

		viewer.input = library
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) VilimaLibrary library) {
		this.library = library

		if (viewer != null && !viewer.control.disposed) {
			viewer.input = library
		}
	}
}
