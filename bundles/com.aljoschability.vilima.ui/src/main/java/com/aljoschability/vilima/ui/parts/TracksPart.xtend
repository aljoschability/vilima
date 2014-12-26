package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.extensions.VilimaFormatter
import com.aljoschability.vilima.ui.VilimaImages
import com.aljoschability.vilima.ui.extensions.SwtExtension
import java.util.function.Function
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
import org.eclipse.swt.events.ControlAdapter
import org.eclipse.swt.events.ControlEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.TableColumn
import org.eclipse.swt.custom.SashForm
import java.util.Collection
import org.eclipse.swt.widgets.Text

class TracksPart {
	extension SwtExtension = SwtExtension::INSTANCE

	Collection<MkTrack> input

	TableViewer viewer

	Text detailsUidText

	@PostConstruct
	def postConstruct(Composite parent) {
		val sash = parent.newSashForm(SWT::HORIZONTAL, [layoutData = newGridData(true, true)])

		sash.createTable()

		sash.createDetails()

		sash.weights = #[4, 1]
	}

	def void createTable(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		viewer = composite.newTableViewer(
			[
				table.layoutData = newGridData(true, true)
				table.headerVisible = true
				table.linesVisible = true
				contentProvider = ArrayContentProvider::getInstance()
				comparator = new ViewerComparator() {
					override compare(Viewer viewer, Object a, Object b) {
						if(a instanceof MkTrack) {
							if(b instanceof MkTrack) {
								return Long.compare(a.number, b.number)
							}
						}
						super.compare(viewer, a, b)
					}
				}
				addSelectionChangedListener(
					[ e |
						val selection = e.selection as IStructuredSelection
						selectTrack(selection.firstElement as MkTrack)
					])
			], SWT::SINGLE, SWT::FULL_SELECTION, SWT::BORDER)

		createColumn("Number", 56, [t|String::valueOf(t.number ?: "")], true)
		createColumn("UID", 80, [t|String::valueOf(t.uid ?: "")])
		createColumn("Enabled", 80, [t|String::valueOf(t.flagEnabled ?: "")])
		createColumn("Default", 80, [t|String::valueOf(t.flagDefault ?: "")])
		createColumn("Forced", 80, [t|String::valueOf(t.flagForced ?: "")])
		createColumn("Lacing", 80, [t|String::valueOf(t.flagLacing ?: "")])
		createColumn("Name", 100, [t|t.name])
		createColumn("Codec", 160, [t|t.codec])
		createColumn("Language", 64, [t|t.language])
		createColumn("Audio Channels", 100, [t|String::valueOf(t.audioChannels ?: "")])
		createColumn("Audio Frequency", 108, [t|String::valueOf(t.audioSamplingFrequency ?: "")])
		createColumn("Video Width", 77, [t|String::valueOf(t.videoPixelWidth ?: "")])
		createColumn("Video Height", 82, [t|String::valueOf(t.videoPixelHeight ?: "")])
		createColumn("Info", 160, [t|VilimaFormatter::getTrackInfo(t)])

		viewer.input = input
	}

	def void createDetails(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		val group = composite.newGroup [
			text = "Details"
			layout = newGridLayoutSwt(2)
			layoutData = newGridData(true, true)
		]

		// video
		val uidLabel = group.newLabel(SWT::TRAIL,
			[
				text = "UID:"
			])

		detailsUidText = group.newText(
			[
				layoutData = newGridData(true, false)
			], SWT::LEAD, SWT::BORDER)
	}

	private def void selectTrack(MkTrack track) {
		if(detailsUidText.active) {
			detailsUidText.text = String::valueOf(track?.uid ?: "")
		}
		println('''track selected: «track»''')
	}

	def private void createColumn(String title, int width, Function<MkTrack, String> function) {
		createColumn(title, width, function, false)
	}

	def private void createColumn(String title, int width, Function<MkTrack, String> function, boolean showIcon) {
		val column = new TableColumn(viewer.table, SWT::LEAD)
		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = title

		column.addControlListener(
			new ControlAdapter {
				override controlResized(ControlEvent e) {
					println((e.widget as TableColumn).width)
				}
			})

		val viewerColumn = new TableViewerColumn(viewer, column)
		viewerColumn.labelProvider = new ColumnLabelProvider() {
			override getText(Object element) {
				if(element instanceof MkTrack) {
					val value = function.apply(element)
					if(value != null) {
						return String::valueOf(value)
					}
				}
				return ""
			}

			override getImage(Object element) {
				if(showIcon) {
					if(element instanceof MkTrack) {
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
								return null
							}
						}
					}
				}
			}
		}
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if(selection != null && selection.size() == 1) {
			val element = selection.firstElement
			if(element instanceof MkFile) {
				input = element.tracks
			}
		}

		if(viewer.active) {
			viewer.input = input
		}
	}
}
