package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.format.VilimaFormatter
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite

class SegmentTitleColumn implements EditableColumnProvider {
	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.title ?: "" }
		}
	}

	override getValue(MkFile file) {
		file?.information?.title ?: ""
	}

	override setValue(MkFile file, Object newValue) {
		val oldValue = getValue(file)

		if(oldValue != newValue) {

			//file.information.title = newValue as String
			println('''Store segment title: "«oldValue»" := "«newValue»".''')

			return true
		}

		return false
	}
}

class SegmentDurationProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::getTime(file?.information?.duration) }
		}
	}
}

class SegmentDateProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { VilimaFormatter::date(file?.information?.date) }
		}
	}
}

class SegmentUidProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.uid }

			override getFont(Object element) { JFaceResources::getTextFont }
		}
	}
}

class SegmentPreviousUidProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.previousUid }

			override getFont(Object element) { JFaceResources::getTextFont }
		}
	}
}

class SegmentNextUidProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.nextUid }

			override getFont(Object element) { JFaceResources::getTextFont }
		}
	}
}

class SegmentMuxingAppProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.muxingApp }
		}
	}
}

class SegmentWritingAppProvider implements ColumnProvider {
	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file?.information?.writingApp }
		}
	}
}
