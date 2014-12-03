package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.widgets.Composite

import static extension com.aljoschability.vilima.ui.columns.TagContentTypeColumn.*

class TagContentTypeColumn implements EditableColumnProvider {
	override getCellEditor(Composite parent, MkFile file) {
		new TextCellEditor(parent)
	}

	override getValue(MkFile file) { file.contentType }

	override setValue(MkFile file, Object newValue) {
		val oldValue = getValue(file)

		if(oldValue != newValue) {

			//file.information.title = newValue as String
			println('''Store tag[CONTENT_TYPE]: "«oldValue»" := "«newValue»".''')

			return true
		}

		return false
	}

	def private static String getContentType(MkFile file) {
		var String text = null
		for (tag : file.tags) {
			for (node : tag.nodes) {
				if(node.name == "CONTENT_TYPE") {
					text = node.value
				}
			}
		}
		return text ?: ""

	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) { file.contentType }
		}
	}
}
