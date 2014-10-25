package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.VilimaLibrary
import com.aljoschability.vilima.format.VilimaFormatter
import java.util.List
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.e4.ui.workbench.modeling.ESelectionService
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TableViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ControlEvent
import org.eclipse.swt.events.ControlListener
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Menu
import org.eclipse.swt.widgets.MenuItem
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.TableColumn

import static com.aljoschability.vilima.ui.parts.TableShowsPart.*

class TableShowsPart {
	@Inject Display display
	@Inject ESelectionService selectionService

	TableViewer viewer

	Object input

	@PostConstruct
	def void create(Composite parent) {
		var table = new Table(parent, SWT::FULL_SELECTION.bitwiseOr(SWT::MULTI))
		table.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		table.headerVisible = true
		table.linesVisible = true

		viewer = new TableViewer(table)
		viewer.contentProvider = ArrayContentProvider::getInstance
		viewer.addSelectionChangedListener(
			[ e |
				selectionService.selection = viewer.selection
			])

		// the file name
		createFileNameColumn()

		// show
		createShowColumn()

		// genres
		createGenresColumn()

		// season
		createSeasonColumn()

		// season
		createEpisodeColumn()

		// title
		createTitleColumn()

		// date
		createDateColumn()

		// the file size
		createSizeColumn()

		// the segment duration
		createDurationColumn()

		viewer.input = input
	}

	def private void createFileNameColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 160
		column.text = "File Name"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			Image image

			override getText(Object element) {
				if (element instanceof MkFile) {
					return String.valueOf(element.getName)
				}
				return ""
			}

			override getImage(Object element) {
				if (image == null) {
					val data = Program::findProgram("mkv").imageData
					image = new Image(display, data)
				}
				return image
			}

			override dispose() {
				if (image != null) {
					image.dispose()
				}

				super.dispose()
			}
		}
	}

	def private void createShowColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 100
		column.text = "Show"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return findTagString(element, 70, "TITLE")
				}
				return ""
			}
		}
	}

	def private void createGenresColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 100
		column.text = "Genres"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					val b = new StringBuilder

					for (genre : findTagStrings(element, 70, "GENRE")) {
						b.append(genre)
						b.append(", ")
					}

					if (b.length != 0) {
						return b.toString().substring(0, b.length - 2)
					}
				}
				return ""
			}
		}
	}

	def private void createSeasonColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		column.moveable = true
		column.resizable = true
		column.width = 27
		column.text = "S"
		column.toolTipText = "Season"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return findTagString(element, 60, "PART_NUMBER")
				}
				return ""
			}
		}
	}

	def private void createEpisodeColumn() {
		val column = new TableColumn(viewer.table, SWT::CENTER)

		val menu = new Menu(viewer.table.shell, SWT::POP_UP)

		val item = new MenuItem(menu, SWT::PUSH)
		item.text = "Test"
		viewer.table.menu = menu

		column.moveable = true
		column.resizable = true
		column.width = 27
		column.text = "E"
		column.toolTipText = "Episode"
		column.addControlListener(
			new ControlListener() {

				override controlMoved(ControlEvent e) {
				}

				override controlResized(ControlEvent e) {
					println(column.width)
				}

			})

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return findTagString(element, 50, "PART_NUMBER")
				}
				return ""
			}
		}
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
				if (element instanceof MkFile) {
					return findTagString(element, 50, "TITLE")
				}
				return ""
			}
		}
	}

	def private void createDateColumn() {
		val column = new TableColumn(viewer.table, SWT::LEAD)

		column.moveable = true
		column.resizable = true
		column.width = 100
		column.text = "Date"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return findTagString(element, 50, "DATE_RELEASE")
				}
				return ""
			}
		}
	}

	def private void createSizeColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 68
		column.text = "Size"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					return VilimaFormatter::fileSize(element.getSize)
				}
				return ""
			}
		}
	}

	def private void createDurationColumn() {
		val column = new TableColumn(viewer.table, SWT::TRAIL)

		column.moveable = true
		column.resizable = true
		column.width = 71
		column.text = "Duration"

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if (element instanceof MkFile) {
					if (element.getInformation != null) {
						return VilimaFormatter::getTime(element.getInformation.getDuration)
					}
				}
				return ""
			}
		}
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) VilimaLibrary content) {
		input = content.files

		if (viewer != null && !viewer.control.disposed) {
			viewer.input = input
		}
	}

	def private static String findTagString(MkFile file, int level, String name) {
		for (tag : file.tags) {
			if (tag.getTarget == level) {
				for (entry : tag.nodes) {
					if (entry.getName == name) {
						return entry.getValue
					}
				}
			}
		}
		return ""
	}

	def private static List<String> findTagStrings(MkFile file, int level, String name) {
		val list = newArrayList
		for (tag : file.tags) {
			if (tag.getTarget == level) {
				for (entry : tag.nodes) {
					if (entry.getName == name) {
						list += entry.getValue
					}
				}
			}
		}
		return list
	}
}
