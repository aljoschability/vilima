package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkvFile
import com.aljoschability.vilima.VilimaFactory
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
import com.aljoschability.vilima.reading.MatroskaReader

class EditPart {
	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::swtDefaults.create

		createFileGroup(composite)

		createButton(composite)
	}

	private def createFileGroup(Composite parent) {
		val group = new Composite(parent, SWT::NONE)
		group.layout = GridLayoutFactory::swtDefaults.numColumns(2).create

		// title
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

						val reader = new MatroskaReader()

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

	def private show(MkvFile file) {
		println("show " + file)
	}
}
