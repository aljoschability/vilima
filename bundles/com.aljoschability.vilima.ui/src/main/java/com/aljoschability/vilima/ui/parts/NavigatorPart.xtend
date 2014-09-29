package com.aljoschability.vilima.ui.parts

import javax.annotation.PostConstruct
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import org.eclipse.jface.layout.GridLayoutFactory

class NavigatorPart {
	TreeViewer viewer

	@PostConstruct
	def void create(Composite parent) {
		parent.layout = GridLayoutFactory::fillDefaults.margins(6, 6).create

		// tree
		var tree = new Tree(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::BORDER).bitwiseOr(SWT::MULTI))
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		viewer = new TreeViewer(tree)
	}
}
