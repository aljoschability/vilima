package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.format.VilimaFormatter
import com.google.common.io.Files
import java.nio.file.Paths
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite

class FileNameProvider implements EditableColumnProvider {
	def String getText(MkFile file) { file?.name ?: "" }

	override compare(MkFile file1, MkFile file2) {
		return file1.text.compareToIgnoreCase(file2.text)
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { FileNameProvider.this.getText(file) }
		}
	}

	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getValue(MkFile file) {
		file.text
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
	def String getText(MkFile file) { file?.path ?: "" }

	override compare(MkFile file1, MkFile file2) {
		return file1.text.compareToIgnoreCase(file2.text)
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { FileFolderProvider.this.getText(file) }
		}
	}
}

class FileSizeProvider implements ColumnProvider {
	def Long getValue(MkFile file) { file?.size ?: -1l }

	override compare(MkFile file1, MkFile file2) {
		return file1.value <=> file2.value
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::fileSize(file.size) }
		}
	}
}

class FileCreationDateTimeProvider implements ColumnProvider {
	def Long getValue(MkFile file) { file?.dateCreated }

	override compare(MkFile file1, MkFile file2) {
		val value1 = file1.value
		val value2 = file2.value
		if(value1 != null) {
			return value1 <=> value2
		}
		if(value2 != null) {
			return -value2 <=> value1
		}
		return 0
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) {
				VilimaFormatter::date(file?.dateCreated)
			}
		}
	}
}

class FileModificationDateTimeProvider implements ColumnProvider {
	def Long getValue(MkFile file) { file?.dateModified }

	override compare(MkFile file1, MkFile file2) {
		val value1 = file1.value
		val value2 = file2.value
		if(value1 != null) {
			return value1 <=> value2
		}
		if(value2 != null) {
			return -value2 <=> value1
		}
		return 0
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::date(file?.dateModified) }
		}
	}
}
