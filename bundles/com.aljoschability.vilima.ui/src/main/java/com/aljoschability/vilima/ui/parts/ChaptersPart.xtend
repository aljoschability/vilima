package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.extensions.VilimaFormatter
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Tree
import org.eclipse.swt.widgets.TreeColumn
import com.aljoschability.vilima.MkChapterText

class ChaptersTreeContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		if(element instanceof MkFile) {
			return element.editions
		}

		if(element instanceof MkEdition) {
			return element.chapters
		}

		if(element instanceof MkChapter) {
			return element.texts
		}

		return super.getElements(element)
	}

	override getChildren(Object element) { getElements(element) }

	override getParent(Object element) {}

	override hasChildren(Object element) { !element.children.empty }
}

class ChaptersPart {
	TreeViewer viewer

	MkFile input

	@PostConstruct
	def postConstruct(Composite parent) {
		val tree = new Tree(parent, SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION))
		tree.headerVisible = true
		tree.linesVisible = true

		viewer = new TreeViewer(tree)
		viewer.contentProvider = new ChaptersTreeContentProvider

		createChapterColumn("Title", 160, SWT::LEAD, false,
			[ element |
				if(element instanceof MkEdition) {
					return '''«element.uid»|«element.flagDefault»|«element.flagHidden»'''
				}
				if(element instanceof MkChapter) {
					val b = new StringBuilder()
					for (display : element.texts) {
						b.append(display.getText)
						b.append(" (")
						b.append(display.getLanguages)
						b.append("), ")
					}
					return b.toString().substring(0, b.length - 2)
				}
				if(element instanceof MkChapterText) {
				}
				return String.valueOf(element)
			])

		createChapterColumn("Start", 90, SWT::LEAD, true,
			[ element |
				if(element instanceof MkEdition) {
					return "Edition " + element.getUid
				}
				if(element instanceof MkChapter) {
					return VilimaFormatter::getTime(element.timeStart / 1000000d, true)
				}
				return String.valueOf(element)
			])

		viewer.input = input
	}

	def private createChapterColumn(String title, int width, int style, boolean monospaced, (Object)=>String function) {
		val column = new TreeColumn(viewer.tree, style)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = title

		val viewerColumn = new TreeViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				return function.apply(element)
			}

			override getFont(Object element) {
				if(monospaced) {
					return JFaceResources::getTextFont
				}
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if(selection != null && selection.size() == 1) {
			val selected = selection.firstElement
			if(selected instanceof MkFile) {
				input = selected
			}
		}

		if(viewer != null && !viewer.control.disposed) {
			viewer.input = input
		}
	}
}
