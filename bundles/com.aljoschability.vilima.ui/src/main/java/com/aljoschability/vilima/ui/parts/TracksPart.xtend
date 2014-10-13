package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.format.VilimaFormatter
import com.aljoschability.vilima.ui.VilimaImages
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
import org.eclipse.jface.viewers.Viewer
import org.eclipse.jface.viewers.ViewerComparator
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn

import com.aljoschability.vilima.VilimaFile
import com.aljoschability.vilima.VilimaFileTrack
import static com.aljoschability.vilima.VilimaFileTrackType.*

class TracksPart {
	Object input

	TableViewer viewer

	@PostConstruct
	def postConstruct(Composite parent) {
		val table = new Table(parent, SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION))
		table.headerVisible = true
		table.linesVisible = true

		viewer = new TableViewer(table)
		viewer.contentProvider = ArrayContentProvider::getInstance()
		viewer.comparator = new ViewerComparator() {
			override compare(Viewer viewer, Object a, Object b) {
				if (a instanceof VilimaFileTrack) {
					if (b instanceof VilimaFileTrack) {
						return Integer.compare(a.getNumber, b.getNumber)
					}
				}
				super.compare(viewer, a, b)
			}
		}

		createTrackColumn()
		createLanguageColumn()
		createNameColumn()

		viewer.input = input
	}

	def private void createTrackColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "Track"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaFileTrack) {
					return VilimaFormatter::getTrackInfo(element)
				}
				return ""
			}

			override getImage(Object element) {
				if (element instanceof VilimaFileTrack) {
					switch (element.getType) {
						case VIDEO: {
							return VilimaImages::image(VilimaImages::TRACK_TYPE_VIDEO)
						}
						case AUDIO: {
							return VilimaImages::image(VilimaImages::TRACK_TYPE_AUDIO)
						}
						case SUBTITLE: {
							return VilimaImages::image(VilimaImages::TRACK_TYPE_SUBTITLE)
						}
						default: {
							println("trying to show image for track - type not known: " + element.getType)
						}
					}
				}

				return null
			}
		}
	}

	def private void createLanguageColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 90
		column.text = "Language"
		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaFileTrack) {
					return VilimaFormatter::getLanguage(element.getLanguage)
				}
				return ""
			}
		}
	}

	def private void createNameColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 100
		column.text = "Name"
		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof VilimaFileTrack) {
					val name = element.getName
					if (name != null) {
						return name
					}
				}
				return ""
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if (selection != null && selection.size() == 1) {
			val element = selection.firstElement
			if (element instanceof VilimaFile) {
				input = element.tracks
			}
		}

		if (viewer != null && !viewer.table.disposed) {
			viewer.input = input
		}
	}
}
