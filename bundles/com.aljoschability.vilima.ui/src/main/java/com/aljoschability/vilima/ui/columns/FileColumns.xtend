package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.format.VilimaFormatter
import com.google.common.io.Files
import java.nio.file.Paths
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite

class FileNameProvider implements EditableColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file.name }
		}
	}

	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getValue(MkFile file) {
		file.name
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

class FileFolderProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file.path }
		}
	}
}

class FileSizeProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::fileSize(file.size) }
		}
	}
}

class FileCreationDateTimeProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) {
				VilimaFormatter::date(file?.dateCreated)
			}
		}
	}
}

class FileModificationDateTimeProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::date(file?.dateModified) }
		}
	}
}
