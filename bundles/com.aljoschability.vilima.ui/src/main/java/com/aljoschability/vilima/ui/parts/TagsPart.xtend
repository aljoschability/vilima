package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import com.aljoschability.vilima.ui.tests_unused.DataAllPartContentProvider

class TagsPart {
	MkFile input

	TreeViewer viewer

	@PostConstruct
	def postConstruct(Composite parent) {
		val composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		composite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// tree
		val tree = new Tree(composite, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION))
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		viewer = new TreeViewer(tree)
		viewer.autoExpandLevel = TreeViewer::ALL_LEVELS
		viewer.tree.headerVisible = true
		viewer.tree.linesVisible = true

		// description
		val descriptionColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		descriptionColumn.column.resizable = true
		descriptionColumn.column.text = "Description"
		descriptionColumn.column.width = 120
		descriptionColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					MkTag: {
						return '''Tag'''
					}
					MkTagNode: {
						return String.valueOf(element.name)
					}
				}
				return super.getText(element)
			}
		}

		// value
		val valueColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		valueColumn.column.resizable = true
		valueColumn.column.text = "Value"
		valueColumn.column.width = 160
		valueColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					MkTag: {
						return '''«element.target»:«element.targetText»'''
					}
					MkTagNode: {
						return String.valueOf(element.value)
					}
				}
				return super.getText(element)
			}
		}

		// target
		val langColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		langColumn.column.resizable = true
		langColumn.column.text = "Language"
		langColumn.column.width = 100
		langColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					MkTag: {
						return ""
					}
					MkTagNode: {
						return String.valueOf(element.language)
					}
				}
				return super.getText(element)
			}
		}

		viewer.contentProvider = new DataAllPartContentProvider

	//		viewer.labelProvider = new DataAllPartLabelProvider
	}

	def private show(MkFile file) {
		viewer.input = file
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if(selection != null && selection.size() == 1) {
			val selected = selection.getFirstElement();
			if(selected instanceof MkFile) {
				input = selected
			}
		}

		if(viewer != null && !viewer.control.disposed) {
			show(input)
		}
	}
}
