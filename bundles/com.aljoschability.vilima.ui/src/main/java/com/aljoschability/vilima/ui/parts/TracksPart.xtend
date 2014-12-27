package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.ui.VilimaImages
import com.aljoschability.vilima.ui.extensions.SwtExtension
import com.aljoschability.vilima.ui.widgets.MkTrackDetailCheckWidget
import com.aljoschability.vilima.ui.widgets.MkTrackDetailTextWidget
import com.aljoschability.vilima.ui.widgets.MkTrackDetailWidget
import java.util.Collection
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
import org.eclipse.swt.widgets.Text

import static extension com.aljoschability.vilima.ui.parts.TracksPart.*

class TracksPart {
	extension SwtExtension = SwtExtension::INSTANCE

	Collection<MkTrack> input

	TableViewer viewer

	Text detailsLanguageText

	MkTrackDetailWidget uidWidget
	MkTrackDetailWidget nameWidget

	MkTrackDetailWidget flagEnabledWidget
	MkTrackDetailWidget flagLacingWidget
	MkTrackDetailWidget flagDefaultWidget
	MkTrackDetailWidget flagForcedWidget

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

		createColumn("Type", 96, [t|t.formatType], true)
		createColumn("Name", 100, [t|t.formatName])
		createColumn("Codec", 160, [t|t.formatCodec])

		createColumn("Number", 56, [t|String::valueOf(t.number ?: "")])
		createColumn("Audio Channels", 100, [t|String::valueOf(t.audioChannels ?: "")])
		createColumn("Audio Frequency", 108, [t|String::valueOf(t.audioSamplingFrequency ?: "")])
		createColumn("Video Width", 77, [t|String::valueOf(t.videoPixelWidth ?: "")])
		createColumn("Video Height", 82, [t|String::valueOf(t.videoPixelHeight ?: "")])

		viewer.input = input
	}

	private static def String formatType(MkTrack track) {
		track.type.toString.toLowerCase.toFirstUpper
	}

	private static def String formatName(MkTrack track) {
		track.name ?: ""
	}

	private static def String formatCodec(MkTrack track) {
		track.codec ?: ""
	}

	def void createDetails(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		val group = composite.newGroup [
			text = "Details"
			layout = newGridLayoutSwt(3)
			layoutData = newGridData(true, true)
		]

		// UID
		uidWidget = new MkTrackDetailTextWidget("UID", "The unique identifier for the track.") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.text = String::valueOf(track?.uid ?: "")
			}
		}
		uidWidget.create(group)

		// name
		nameWidget = new MkTrackDetailTextWidget("Name", "The name of the track.") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.text = String::valueOf(track?.name ?: "")
			}
		}
		nameWidget.create(group)

		// language
		//		detailsLanguageText = group.newDetailText("Language")
		//		group.newLabel([], SWT::NONE)
		// flags
		flagEnabledWidget = new MkTrackDetailCheckWidget("Enabled", "Whether or this track is enabled.") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.selection = track?.flagEnabled ?: true
			}
		}
		flagEnabledWidget.create(group)

		flagDefaultWidget = new MkTrackDetailCheckWidget("Default", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.selection = track?.flagDefault ?: true
			}
		}
		flagDefaultWidget.create(group)

		flagForcedWidget = new MkTrackDetailCheckWidget("Forced", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.selection = track?.flagForced ?: false
			}
		}
		flagForcedWidget.create(group)

		flagLacingWidget = new MkTrackDetailCheckWidget("Lacing", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.selection = track?.flagLacing ?: true
			}
		}
		flagLacingWidget.create(group)
	}

	private def void selectTrack(MkTrack track) {
		uidWidget.update(track)
		nameWidget.update(track)

		flagEnabledWidget.update(track)
		flagDefaultWidget.update(track)
		flagForcedWidget.update(track)
		flagLacingWidget.update(track)

	//		if(detailsLanguageText.active) {
	//			detailsLanguageText.text = String::valueOf(track?.language ?: "")
	//		}
	//
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
