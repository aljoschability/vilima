package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.ui.services.DialogService
import com.aljoschability.vilima.ui.xtend.SwtExtension
import org.eclipse.e4.core.contexts.IEclipseContext
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.viewers.DialogCellEditor
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Shell

class GenresSelectionDialog extends Dialog {
	extension SwtExtension = SwtExtension::INSTANCE
	IDialogSettings settings

	TableViewer viewer

	new(IEclipseContext context) {
		super(context.get(Shell))

		settings = context.get(DialogService).getSettings(GenresSelectionDialog)
	}

	override protected createDialogArea(Composite parent) {
		val composite = super.createDialogArea(parent) as Composite

		createLeftSide(composite)

		return composite
	}

	def private void createLeftSide(Composite parent) {
		viewer = new TableViewer(parent, SWT::BORDER.bitwiseOr(SWT::MULTI))
		viewer.control.layoutData = newGridData(true, true)

	}

	override protected getDialogBoundsSettings() { settings }

	override protected isResizable() { true }
}

class VideoCodecPrivateColumn extends AbstractStringColumn {
	override protected getString(MkFile file) {
		val text = new StringBuilder
		for (track : file.tracks) {
			if(track.type == MkTrackType::VIDEO) {
				if(text.length > 0) {
					text.append(", ")
				}
				text.append(AudioCodecPrivateColumn::format(track.getCodec))
			}
		}
		return text.toString
	}
}

class AudioCodecPrivateColumn extends AbstractStringColumn {
	override protected getString(MkFile file) {
		val text = new StringBuilder
		for (track : file.tracks) {
			if(track.type == MkTrackType::AUDIO) {
				if(text.length > 0) {
					text.append(", ")
				}
				text.append(AudioCodecPrivateColumn::format(track.getCodec))
			}
		}
		return text.toString
	}

	def static String format(String codec) {
		if(codec != null) {
			switch codec {
				case "A_AAC":
					return "AAC"
				case "A_AC3":
					return "AC3"
				case "A_DTS":
					return "DTS"
				case "A_MPEG/L3":
					return "MP3"
				case "A_VORBIS":
					return "Vorbis"
				case codec.startsWith("V_MPEG4/ISO/AVC"): {
					val split = codec.substring(16).split("/")
					val profile = switch split.get(0) {
						case "100": "High"
						case "77": "Main"
						default: '''? («split.get(0)»)'''
					}
					val level = switch split.get(1) {
						case "30": "3.0"
						case "31": "3.1"
						case "40": "4.0"
						case "41": "4.1"
						case "42": "4.2"
						default: '''? («split.get(1)»)'''
					}

					return '''AVC «profile»@«level»'''
				}
				case codec.startsWith("V_MS/VFW/FOURCC"): {
					return '''VFW «codec.substring(16)»'''
				}
				case "S_TEXT/UTF8":
					return "UTF-8 Plain Text"
			}
		}
	}
}

class TestColumn extends AbstractStringColumn {
	EditingSupport editingSupport

	override getEditingSupport(TreeViewer treeViewer) {
		if(editable && editingSupport == null) {
			editingSupport = new EditingSupport(treeViewer) {
				override protected canEdit(Object element) {
					element instanceof MkFile
				}

				override protected getCellEditor(Object element) {
					val editor = new DialogCellEditor(treeViewer.tree) {
						override protected openDialogBox(Control parent) {

							// TODO: we will need the current eclipse context reference!
							val context = null
							val dialog = new GenresSelectionDialog(context)

							return dialog.open
						}
					}

					return editor
				}

				override protected getValue(Object element) {
					(element as MkFile).string ?: ""
				}

				override protected setValue(Object element, Object value) {
					if(value instanceof String) {
						if(set(element as MkFile, value as String)) {
							viewer.update(element, null)
						}
					}
				}
			}
		}
		return editingSupport
	}

	override protected isEditable() { true }

	override protected getString(MkFile file) {
		val text = new StringBuilder
		for (node : file.getAllTagNodes(50, "GENRE")) {
			text.append(node.value)
			text.append(", ")
		}
		return text.toString
	}
}
