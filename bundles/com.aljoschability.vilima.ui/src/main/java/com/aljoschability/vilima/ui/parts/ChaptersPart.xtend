package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.format.VilimaFormatter
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TableViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkEdition

class ChaptersPart {
	TableViewer viewer

	Object input

	@PostConstruct
	def postConstruct(Composite parent) {
		val table = new Table(parent, SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION))
		table.headerVisible = true
		table.linesVisible = true

		viewer = new TableViewer(table)
		viewer.contentProvider = new VilimaChaptersViewerContentProvider

		createTitleColumn()
		createStartColumn()

		viewer.input = input
	}

	def private void createTitleColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "Title"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
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

				return ""
			}
		}
	}

	def private void createStartColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 90
		column.text = "Start"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if(element instanceof MkEdition) {
					return "Edition " + element.getUid
				}

				if(element instanceof MkChapter) {
					return VilimaFormatter::getTime(element.start / 1000000d, true)
				}

				return ""
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if(selection != null && selection.size == 1) {
			val selected = selection.firstElement
			if(selected instanceof MkFile) {
				if(selected.editions.size == 1) {
					input = selected.editions.get(0)
				}
			}
		}

		if(viewer != null && !viewer.control.disposed) {
			viewer.input = input
		}
	}
}

class VilimaChaptersViewerContentProvider extends ArrayContentProvider {
	override getElements(Object element) {
		if(element instanceof MkEdition) {
			return element.chapters
		}

		return newArrayOfSize(0)
	}
}
