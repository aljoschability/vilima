package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.ui.extensions.SwtExtension
import com.aljoschability.vilima.ui.services.ImageService
import com.aljoschability.vilima.ui.widgets.BaseTextWidget
import com.aljoschability.vilima.ui.widgets.MkTrackNameWidget
import com.aljoschability.vilima.ui.widgets.MkTrackUidWidget
import java.util.Collection
import java.util.function.Function
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.EMenuService
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
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.TableColumn

import static extension com.aljoschability.vilima.ui.parts.TracksPart.*

class TracksPart {
	static val ID_CONTEXT_MENU = "com.aljoschability.vilima.menu.popup.tracks"

	extension SwtExtension = SwtExtension::INSTANCE

	@Inject ImageService imageService
	@Inject EMenuService menuService

	Collection<MkTrack> input

	TableViewer viewer

	BaseTextWidget<MkTrack> uidWidget
	BaseTextWidget<MkTrack> nameWidget
	BaseTextWidget<MkTrack> languageWidget

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
		val column = createColumn("Name", 100, [t|t.formatName])

		//		createDataBinding(column)
		createColumn("Codec", 160, [t|t.formatCodec])

		createColumn("Number", 56, [t|String::valueOf(t.number ?: "")])
		createColumn("Audio Channels", 100, [t|String::valueOf(t.audioChannels ?: "")])
		createColumn("Audio Frequency", 108, [t|String::valueOf(t.audioSamplingFrequency ?: "")])
		createColumn("Video Width", 77, [t|String::valueOf(t.videoPixelWidth ?: "")])
		createColumn("Video Height", 82, [t|String::valueOf(t.videoPixelHeight ?: "")])

		menuService.registerContextMenu(viewer.control, ID_CONTEXT_MENU)

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
		uidWidget = new MkTrackUidWidget
		uidWidget.create(group)

		// name
		nameWidget = new MkTrackNameWidget
		nameWidget.create(group)

	// language
	/*
		languageWidget = new BaseTextWidget<MkTrack>("Language") {
			override getValue(MkTrack element) {
				element?.language
			}

			override setValue(MkTrack element, String value) {
				element.language = value
			}

			override protected getStatus(MkTrack element) {
				if(element?.language == "test") {
					return newError("The language must not be 'test'.")
				}
				return newInformation("The language of the track.")
			}
		}
		languageWidget.create(group)

		// enabled
		flagEnabledWidget = new HelpfulCheckboxEditingWidget<MkTrack>(group, "Enabled") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.grayed = track?.flagEnabled == null
				widget.selection = track?.flagEnabled ?: true
			}
		}
		flagEnabledWidget.create(group)

		// default
		flagDefaultWidget = new HelpfulCheckboxEditingWidget<MkTrack>("Default", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.grayed = track?.flagDefault == null
				widget.selection = track?.flagDefault ?: true
			}
		}
		flagDefaultWidget.create(group)

		// forced
		flagForcedWidget = new HelpfulCheckboxEditingWidget<MkTrack>("Forced", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.grayed = track?.flagForced == null
				widget.selection = track?.flagForced ?: false
			}
		}
		flagForcedWidget.create(group)

		// lacing
		flagLacingWidget = new HelpfulCheckboxEditingWidget<MkTrack>("Lacing", "???") {
			override protected updateContents(MkTrack track) {
				widget.enabled = track != null
				widget.grayed = track?.flagLacing == null
				widget.selection = track?.flagLacing ?: true
			}
		}
		flagLacingWidget.create(group)
*/
	}

	private def void selectTrack(MkTrack track) {
		uidWidget.input = track
		nameWidget.input = track

	/*
		 * languageWidget.input = track

	flagEnabledWidget.input = track
		flagDefaultWidget.input = track
		flagForcedWidget.input = track
		flagLacingWidget.input = track*/
	}

	def private TableViewerColumn createColumn(String title, int width, Function<MkTrack, String> function) {
		createColumn(title, width, function, false)
	}

	def private TableViewerColumn createColumn(String title, int width, Function<MkTrack, String> function,
		boolean showIcon) {
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
						return switch element.type {
							case VIDEO: ImageService::IMG_TRACK_VIDEO.asImage
							case AUDIO: ImageService::IMG_TRACK_AUDIO.asImage
							case SUBTITLE: ImageService::IMG_TRACK_SUBTITLE.asImage
							default: null
						}
					}
				}
			}
		}
		return viewerColumn
	}

	@Inject Display display

	private def Image asImage(String path) {
		imageService.getImage(display, path)
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
