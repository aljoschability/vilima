package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkvFile
import com.aljoschability.vilima.format.VilimaFormatter
import java.util.Map
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

class InformationPart {
	val Map<String, Label> labelsMap = newLinkedHashMap

	MkvFile input

	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::swtDefaults.create
		composite.layoutData = GridDataFactory::fillDefaults.grab(true, false).create

		createFileGroup(composite)

		createSegmentGroup(composite)
	}

	private def createFileGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::fillDefaults.numColumns(2).margins(6, 6).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "File"

		// path
		val pathLabel = new Label(group, SWT::TRAIL)
		pathLabel.text = "Path"

		val pathData = new Label(group, SWT::LEAD)
		pathData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.path", pathData)

		// name
		val nameLabel = new Label(group, SWT::TRAIL)
		nameLabel.text = "Name"

		val nameData = new Label(group, SWT::LEAD)
		nameData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.name", nameData)

		// size
		val sizeLabel = new Label(group, SWT::TRAIL)
		sizeLabel.text = "Size"

		val sizeData = new Label(group, SWT::LEAD)
		sizeData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("file.size", sizeData)

		// size
		val modifiedLabel = new Label(group, SWT::TRAIL)
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
		val titleLabel = new Label(group, SWT::TRAIL)
		titleLabel.text = "Title"

		val titleData = new Label(group, SWT::LEAD)
		titleData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.title", titleData)

		// muxer
		val muxerLabel = new Label(group, SWT::TRAIL)
		muxerLabel.text = "Muxer"

		val muxerData = new Label(group, SWT::LEAD)
		muxerData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.muxingApp", muxerData)

		// writer
		val writerLabel = new Label(group, SWT::TRAIL)
		writerLabel.text = "Writer"

		val writerData = new Label(group, SWT::LEAD)
		writerData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.writingApp", writerData)

		// date
		val dateLabel = new Label(group, SWT::TRAIL)
		dateLabel.text = "Date"

		val dateData = new Label(group, SWT::LEAD)
		dateData.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		labelsMap.put("segment.date", dateData)
	}

	def private show(MkvFile file) {
		if (file == null) {
			for (key : labelsMap.keySet) {
				labelsMap.get(key).text = ""
			}
			return
		}

		labelsMap.get("file.name").text = String::valueOf(file.fileName)
		labelsMap.get("file.path").text = String::valueOf(file.filePath)
		labelsMap.get("file.size").text = String::valueOf(VilimaFormatter::fileSize(file.fileSize))
		labelsMap.get("file.modified").text = String::valueOf(VilimaFormatter::date(file.fileDate))

		labelsMap.get("segment.title").text = String::valueOf(file.segmentTitle)
		labelsMap.get("segment.date").text = String::valueOf(VilimaFormatter::date(file.segmentDate))
		labelsMap.get("segment.muxingApp").text = String::valueOf(file.segmentMuxingApp)
		labelsMap.get("segment.writingApp").text = String::valueOf(file.segmentWritingApp)
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null

		if (selection != null && selection.size() == 1) {
			val selected = selection.getFirstElement();
			if (selected instanceof MkvFile) {
				input = selected
			}
		}

		if (!labelsMap.empty) {
			show(input)
		}
	}
}
