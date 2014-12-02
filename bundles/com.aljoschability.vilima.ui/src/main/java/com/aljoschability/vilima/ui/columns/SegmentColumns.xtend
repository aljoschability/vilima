package com.aljoschability.vilima.ui.columns

import org.eclipse.swt.widgets.Composite
import com.aljoschability.vilima.MkFile
import org.eclipse.jface.viewers.TextCellEditor
import com.aljoschability.vilima.format.VilimaFormatter

class SegmentTitleColumn implements EditableColumnProvider {
	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getText(MkFile file) {
		file?.information?.title
	}

	override getValue(MkFile file) {
		val value = getText(file)
		if(value != null) {
			return value
		}
		return ""
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

class SegmentDurationColumn implements ColumnProvider {
	override getText(MkFile file) {
		if(file != null && file.information != null) {
			return VilimaFormatter::getTime(file.information.duration)
		}
	}
}
