package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.google.common.io.Files
import java.nio.file.Paths
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite
import com.aljoschability.vilima.format.VilimaFormatter

class FileNameColumn implements EditableColumnProvider {
	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getText(MkFile file) {
		file.name
	}

	override getValue(MkFile file) {
		getText(file)
	}

	override setValue(MkFile file, Object value) {
		val oldFile = Paths::get(file.path, file.name).toFile
		val newFile = Paths::get(file.path, value as String).toFile

		// only if not equal name + not existing
		if(oldFile != newFile && !newFile.exists) {
			Files::move(oldFile, newFile)

			file.name = value as String
			return true
		}

		return false
	}
}

class FileSizeColumn implements ColumnProvider {
	override getText(MkFile file) { VilimaFormatter::fileSize(file.size) }
}

class FileDateModifiedColumn implements ColumnProvider {
	override getText(MkFile file) { VilimaFormatter::date(file.dateModified) }
}
