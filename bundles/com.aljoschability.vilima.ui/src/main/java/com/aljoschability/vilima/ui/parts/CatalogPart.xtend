package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.ui.providers.VilimaCatalogTreeContentProvider
import com.aljoschability.vilima.ui.providers.VilimaCatalogTreeLabelProvider
import javax.annotation.PostConstruct
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree

class CatalogPart {
	TreeViewer viewer

	@PostConstruct
	def postConstruct(Composite parent) {
		val tree = new Tree(parent, SWT::MULTI)

		viewer = new TreeViewer(tree)

		viewer.labelProvider = new VilimaCatalogTreeLabelProvider
		viewer.contentProvider = new VilimaCatalogTreeContentProvider

		viewer.input = createDummyInput()
	}

	private static def createDummyInput() {
		val f = VilimaFactory::eINSTANCE

		val cat = f.createVilimaLibrary

		var genre = f.createVilimaGenre
		genre.name = "Mystery"
		cat.genres += genre

		genre = f.createVilimaGenre
		genre.name = "Thriller"
		cat.genres += genre

		genre = f.createVilimaGenre
		genre.name = "Horror"
		cat.genres += genre

		genre = f.createVilimaGenre
		genre.name = "Action"
		cat.genres += genre

		return cat
	}

}
