package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.ui.providers.VilimaContentProvider
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import org.eclipse.swt.widgets.TreeColumn

class ContentsPart {
	@Inject IContentManager manager

	TreeViewer viewer

	@PostConstruct
	def void create(Composite parent) {
		parent.layout = GridLayoutFactory::fillDefaults.margins(6, 6).create

		var tree = new Tree(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::BORDER).bitwiseOr(SWT::MULTI))
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		tree.headerVisible = true
		tree.linesVisible = true

		viewer = new TreeViewer(tree)
		viewer.contentProvider = new VilimaContentProvider(manager)

		createColumn(viewer, "F: Path", 50, new ColumnLabelProvider)
		createColumn(viewer, "F: Name", 50, new ColumnLabelProvider)
		createColumn(viewer, "F: Size", 50, new ColumnLabelProvider)
		createColumn(viewer, "F: Modified", 50, new ColumnLabelProvider)
		createColumn(viewer, "M: Length", 50, new ColumnLabelProvider)
		createColumn(viewer, "M: Video", 50, new ColumnLabelProvider)
		createColumn(viewer, "M: Audio", 50, new ColumnLabelProvider)
		createColumn(viewer, "M: Text", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Type", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Title", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Subtitle", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Show", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Season", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Episode", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Date", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Certification", 50, new ColumnLabelProvider)
		createColumn(viewer, "T: Genres", 50, new ColumnLabelProvider)
	}

	static def private createColumn(TreeViewer viewer, String text, int width, ColumnLabelProvider labelProvider) {
		createColumn(viewer, text, width, SWT::BEGINNING, labelProvider)
	}

	static def private createColumn(TreeViewer viewer, String text, int width, int style,
		ColumnLabelProvider labelProvider) {
		val column = new TreeColumn(viewer.tree, style)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = text

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = labelProvider
	}

	@Inject @Optional
	def handleClear(@UIEventTopic(VilimaEventTopics::CONTENT_CLEAR) Object object) {
		if (viewer != null) {
			viewer.input = null
			viewer.input = manager.content
		}
	}

//	@Inject @Optional
//	def handleAdd(@UIEventTopic(VilimaEventTopics::CONTENT_ADD) VilimaFile file) {
//		if (viewer != null) {
//		}
//	}
}
