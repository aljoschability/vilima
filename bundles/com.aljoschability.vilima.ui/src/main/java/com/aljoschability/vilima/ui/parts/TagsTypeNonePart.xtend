package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import java.util.List
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import org.eclipse.swt.SWT
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.jface.viewers.LabelProvider
import com.aljoschability.vilima.MkFileTag
import com.aljoschability.vilima.MkFileTagEntry
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory

class TagsTypeNonePart {
	Composite composite

	TreeViewer viewer

	def void create(Composite parent) {
		composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		composite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// tree
		val tree = new Tree(composite, SWT::BORDER)
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		viewer = new TreeViewer(tree)
		viewer.autoExpandLevel = TreeViewer::ALL_LEVELS
		viewer.contentProvider = new DataAllPartContentProvider
		viewer.labelProvider = new DataAllPartLabelProvider
	}

	def setInput(List<MkFile> files) {
		if (files != null && files.size == 1) {
			viewer.input = files.get(0)
		} else {
			viewer.input = null
		}
	}

	def Composite getControl() {
		return composite
	}
}

class DataAllPartContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		return getChildren(element)
	}

	override getChildren(Object element) {
		if (element instanceof MkFile) {
			return element.tags
		}

		if (element instanceof MkFileTag) {
			return element.entries
		}

		if (element instanceof MkFileTagEntry) {
			return element.entries
		}

		return newArrayOfSize(0)
	}

	override getParent(Object element) {
		return null
	}

	override hasChildren(Object element) {
		return !element.children.empty
	}
}

class DataAllPartLabelProvider extends LabelProvider {
	override getText(Object element) {
		if (element instanceof MkFileTag) {
			return '''Tag[«element.target»] («element.targetText»)'''
		}

		if (element instanceof MkFileTagEntry) {
			return '''«element.name»=«element.value» («element.language»)'''
		}

		return super.getText(element)
	}
}

class DataAllPartNode {

	def String getText() {
		return text
	}
}
