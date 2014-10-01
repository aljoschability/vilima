package com.aljoschability.vilima.ui.parts;

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
	}
}
