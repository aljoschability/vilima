package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import org.eclipse.jface.viewers.ColumnLabelProvider

class AttachmentCoverProvider implements ColumnProvider {
	override getLabelProvider() {
		new ColumnLabelProvider {
			override getText(Object element) {
				if(element instanceof MkFile) {
					val covers = #["cover.jpg", "small_cover.jpg", "cover_land.jpg", "small_cover_land.jpg"]
					for (a : element.attachments) {
						if(covers.contains(a.name)) {
							return "YES"
						}
					}
				}
				return ""
			}
		}
	}
}
