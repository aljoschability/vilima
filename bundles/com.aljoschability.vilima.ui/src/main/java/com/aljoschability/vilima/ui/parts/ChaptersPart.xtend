package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.xtend.SwtExtension
import com.aljoschability.vilima.writing.ChapterWriter
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
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.TreeColumn

class ChaptersPart {
	extension SwtExtension = SwtExtension::INSTANCE

	TreeViewer chaptersViewer

	MkFile file
	MkEdition edition

	Text editionUidText
	Button editionFlagHidden
	Button editionFlagDefault
	Button editionFlagOrdered
	TreeViewer editionsViewer

	@PostConstruct
	def postConstruct(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
			layoutData = newGridData(true, true)
		]

		val sash = composite.newSashForm(SWT::HORIZONTAL,
			[
				layoutData = newGridData(true, true)
			])

		sash.createEditionControls

		sash.createChapterControls

		sash.weights = #[1, 3]
	}

	def private void createEditionControls(Composite parent) {
		val group = parent.newGroup [
			layout = newGridLayoutSwt
			text = "Editions"
		]

		val sash = group.newSashForm(SWT::VERTICAL,
			[
				layoutData = newGridData(true, true)
			])

		val editionsTree = sash.newTree(SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::BORDER),
			[
				layoutData = newGridData(true, true)
			])

		editionsViewer = editionsTree.newTreeViewer [
			contentProvider = new ChaptersTreeContentProvider
			addSelectionChangedListener(
				[ s |
					val newEdition = (s.selection as IStructuredSelection).firstElement as MkEdition
					if(newEdition != edition) {
						handleEditionSelection(newEdition)
					}
				])
		]

		// fields
		val editionComposite = sash.newComposite [
			layout = newGridLayoutSwt
		]

		// field: edition.uid
		val editionUid = editionComposite.newComposite [
			layout = newGridLayout(2)
			layoutData = newGridData(true, false)
		]
		editionUid.newLabel(
			[
				text = "UID:"
				layoutData = newGridDataCentered
			], SWT::LEAD)
		editionUidText = editionUid.newText(SWT::LEAD.bitwiseOr(SWT::BORDER),
			[
				layoutData = newGridData(true, false)
				toolTipText = "A unique ID to identify the edition. It's useful for tagging an edition."
			])

		editionFlagHidden = editionComposite.newButton(
			[
				text = "Hidden"
				toolTipText = "If an edition is hidden, it should not be available to the user interface (but still to Control Tracks)."
			], SWT::CHECK)
		editionFlagDefault = editionComposite.newButton(
			[
				text = "Default"
				toolTipText = "If an edition is set to default it should be used as the default one."
			], SWT::CHECK)
		editionFlagOrdered = editionComposite.newButton(
			[
				text = "Ordered"
				toolTipText = "Specify if the chapters can be defined multiple times and the order to play them is enforced."
			], SWT::CHECK)

		sash.weights = #[1, 1]
	}

	def private void createChapterControls(Composite parent) {
		val group = parent.newGroup [
			layout = newGridLayoutSwt(2)
			layoutData = newGridData(true, true)
			text = "Chapters"
		]

		val tree = group.newTree(SWT::MULTI.bitwiseOr(SWT::FULL_SELECTION).bitwiseOr(SWT::BORDER),
			[
				layoutData = newGridData(true, true)
				headerVisible = true
				linesVisible = true
			])

		chaptersViewer = tree.newTreeViewer [
			autoExpandLevel = TreeViewer::ALL_LEVELS
			contentProvider = new ChaptersTreeContentProvider
		]

		createChapterColumn("Entry", 160, SWT::LEAD, false,
			[ element |
				if(element instanceof MkEdition) {
					return '''Edition «element.uid»|«element.flagDefault»|«element.flagHidden»'''
				}
				if(element instanceof MkChapter) {
					return '''«element.uid»/«element.uidString»'''
				}
				if(element instanceof MkChapterText) {
					return '''«element.text» «element.languages»'''
				}
				return String.valueOf(element)
			])

		createChapterColumn("Start", 90, SWT::TRAIL, true,
			[ element |
				if(element instanceof MkChapter) {
					return element.timeStart.formatted
				}
				return ""
			])

		createChapterColumn("End", 90, SWT::TRAIL, true,
			[ element |
				if(element instanceof MkChapter) {
					return element.timeEnd.formatted
				}
				return ""
			])

		createChapterColumn("Duration", 90, SWT::TRAIL, true,
			[ element |
				if(element instanceof MkChapter) {
					return element.duration.formatted
				}
				return ""
			])

		chaptersViewer.input = file

		// controls
		group.createControls
	}

	def private void createControls(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayoutSwt
		]

		val fillIntervalButton = new Button(composite, SWT::PUSH)
		fillIntervalButton.text = "Fill By Interval (every 5 Minutes)"

		val fillPartsButton = new Button(composite, SWT::PUSH)
		fillPartsButton.text = "Split in 5 Parts"

		val importFileButton = new Button(composite, SWT::PUSH)
		importFileButton.text = "Import From File"

		val importChapterDbButton = new Button(composite, SWT::PUSH)
		importChapterDbButton.text = "Load From ChapterDB"
	}

	def private static Long getDuration(MkChapter chapter) {
		val edition = chapter.edition
		val index = edition.chapters.indexOf(chapter)
		if(edition.chapters.size > index + 1) {
			val nextChapter = edition.chapters.get(index + 1)
			nextChapter.timeStart
		}

		return -1l
	}

	def private static String getFormatted(Long value) {
		ChapterWriter::toTime(value)
	}

	def private createChapterColumn(String title, int width, int style, boolean monospaced, (Object)=>String function) {
		val column = new TreeColumn(chaptersViewer.tree, style)

		column.moveable = true
		column.resizable = true
		column.width = width
		column.text = title

		val viewerColumn = new TreeViewerColumn(chaptersViewer, column)
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
	def void handleSelection(@Optional @Named(IServiceConstants::ACTIVE_SELECTION) IStructuredSelection selection) {
		var MkFile newFile = null
		if(selection != null && selection.size == 1) {
			val selected = selection.firstElement
			if(selected instanceof MkFile) {
				newFile = selected
			}
		}

		if(newFile != file) {
			handleFileSelection(newFile)
		}
	}

	def private void handleFileSelection(MkFile file) {
		this.file = file

		if(editionsViewer.active) {
			editionsViewer.input = file?.editions
		}
	}

	def private void handleEditionSelection(MkEdition edition) {
		this.edition = edition

		if(editionUidText.active) {
			if(edition == null) {
				editionUidText.text = ""
				editionUidText.enabled = false
			} else {
				editionUidText.text = String.valueOf(edition.uid)
				editionUidText.enabled = true
			}
		}

		if(editionFlagHidden.active) {
			if(edition == null) {
				editionFlagHidden.selection = false
				editionFlagHidden.enabled = false
			} else {
				editionFlagHidden.selection = edition.flagHidden
				editionFlagHidden.enabled = true
			}
		}

		if(editionFlagDefault.active) {
			if(edition == null) {
				editionFlagDefault.selection = false
				editionFlagDefault.enabled = false
			} else {
				editionFlagDefault.selection = edition.flagDefault
				editionFlagDefault.enabled = true
			}
		}
		if(editionFlagOrdered.active) {
			if(edition == null) {
				editionFlagOrdered.selection = false
				editionFlagOrdered.enabled = false
			} else {
				editionFlagOrdered.selection = edition.flagOrdered
				editionFlagOrdered.enabled = true
			}
		}

		if(chaptersViewer.active) {
			chaptersViewer.input = edition
		}
	}
}

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
