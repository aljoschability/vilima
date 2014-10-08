package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkvChapterEdition
import com.aljoschability.vilima.MkvChapterEntry
import com.aljoschability.vilima.MkvFile
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
				if (element instanceof MkvChapterEntry) {
					val b = new StringBuilder()
					for (display : element.displays) {
						b.append(display.string)
						b.append(" (")
						b.append(display.language)
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
				if (element instanceof MkvChapterEdition) {
					return "Edition " + element.uid
				}

				if (element instanceof MkvChapterEntry) {
					return VilimaFormatter::getTime(element.start / 1000000)
				}

				return ""
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if (selection != null && selection.size == 1) {
			val selected = selection.firstElement
			if (selected instanceof MkvFile) {
				if (selected.editions.size == 1) {
					input = selected.editions.get(0)
				}
			}
		}

		if (viewer != null && !viewer.control.disposed) {
			viewer.input = input
		}
	}
}

class VilimaChaptersViewerContentProvider extends ArrayContentProvider {
	override getElements(Object element) {
		if (element instanceof MkvChapterEdition) {
			return element.entries
		}

		return newArrayOfSize(0)
	}
}
