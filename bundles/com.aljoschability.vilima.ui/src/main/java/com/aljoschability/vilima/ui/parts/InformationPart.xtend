package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkvFile
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.reading.MatroskaFile
import java.io.File
import java.util.Map
import javax.annotation.PostConstruct
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

class InformationPart {
	val Map<String, Label> labelsMap = newLinkedHashMap

	@PostConstruct
	def void create(Composite parent) {
		createFileGroup(parent)

		createSegmentGroup(parent)

		createTagsGroup(parent)

		createTracksGroup(parent)

		createButton(parent)
	}

	private def createFileGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::fillDefaults.numColumns(2).margins(6, 6).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "File"

		// name
		val nameLabel = new Label(group, SWT::LEAD)
		nameLabel.text = "Name"

		val nameData = new Label(group, SWT::LEAD)
		nameData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.name", nameData)

		// path
		val pathLabel = new Label(group, SWT::LEAD)
		pathLabel.text = "Path"

		val pathData = new Label(group, SWT::LEAD)
		pathData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.path", pathData)

		// size
		val sizeLabel = new Label(group, SWT::LEAD)
		sizeLabel.text = "Size"

		val sizeData = new Label(group, SWT::LEAD)
		sizeData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.size", sizeData)

		// size
		val modifiedLabel = new Label(group, SWT::LEAD)
		modifiedLabel.text = "Modified"

		val modifiedData = new Label(group, SWT::LEAD)
		modifiedData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.modified", modifiedData)
	}

	private def createSegmentGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::fillDefaults.numColumns(2).margins(6, 6).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "Segment"

		// title
		val titleLabel = new Label(group, SWT::LEAD)
		titleLabel.text = "Title"

		val titleData = new Label(group, SWT::LEAD)
		titleData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.title", titleData)

		// muxer
		val muxerLabel = new Label(group, SWT::LEAD)
		muxerLabel.text = "Muxer"

		val muxerData = new Label(group, SWT::LEAD)
		muxerData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.muxingApp", muxerData)

		// writer
		val writerLabel = new Label(group, SWT::LEAD)
		writerLabel.text = "Writer"

		val writerData = new Label(group, SWT::LEAD)
		writerData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.writingApp", writerData)

		// date
		val dateLabel = new Label(group, SWT::LEAD)
		dateLabel.text = "Date"

		val dateData = new Label(group, SWT::LEAD)
		dateData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.date", dateData)
	}

	private def createTagsGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::fillDefaults.numColumns(2).margins(6, 6).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "Tags"
	}

	private def createTracksGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::fillDefaults.numColumns(2).margins(6, 6).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "Tracks"
	}

	private def createButton(Composite parent) {
		val button = new Button(parent, SWT::PUSH)
		button.text = "Load..."
		button.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					val dialog = new FileDialog(button.shell, SWT::OPEN)

					val result = dialog.open
					if (result != null) {
						val file = new File(result)

						val reader = new MatroskaFile(false)

						val mkv = VilimaFactory::eINSTANCE.createMkvFile
						mkv.fileDate = file.lastModified
						mkv.fileName = file.name
						mkv.filePath = file.parent
						mkv.fileSize = file.length

						reader.readFile(mkv)

						show(mkv)
					}
				}
			})
	}

	def show(MkvFile file) {
		labelsMap.get("file.name").text = String::valueOf(file.fileName)
		labelsMap.get("file.path").text = String::valueOf(file.filePath)
		labelsMap.get("file.size").text = String::valueOf(file.fileSize)
		labelsMap.get("file.modified").text = String::valueOf(file.fileDate)

		labelsMap.get("segment.title").text = String::valueOf(file.segmentTitle)
		labelsMap.get("segment.date").text = String::valueOf(file.segmentDate)
		labelsMap.get("segment.muxingApp").text = String::valueOf(file.segmentMuxingApp)
		labelsMap.get("segment.writingApp").text = String::valueOf(file.segmentWritingApp)
	}
}
