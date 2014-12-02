package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite

class AbstractTagColumn implements ColumnProvider {
	
	override getText(MkFile file) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}

class TagContentTypeColumn implements EditableColumnProvider {
	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getText(MkFile file) {
		var String text = null
		for (tag : file.tags) {
			for (node : tag.nodes) {
				if(node.name == "CONTENT_TYPE") {
					text = node.value
				}
			}
		}
		return text
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
			println('''Store tag[CONTENT_TYPE]: "«oldValue»" := "«newValue»".''')

			return true
		}

		return false
	}
}
