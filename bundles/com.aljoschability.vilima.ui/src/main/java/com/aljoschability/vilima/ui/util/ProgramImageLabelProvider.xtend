package com.aljoschability.vilima.ui.util

import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.program.Program
import org.eclipse.swt.widgets.Display

class ProgramImageLabelProvider extends ColumnLabelProvider {
	val Display display

	Image image

	new(Display display) {
		this.display = display
	}

	override getText(Object element) { return "" }

	override getImage(Object element) {
		if(image == null) {
			val data = Program::findProgram("mkv").imageData
			image = new Image(display, data)
		}
		return image
	}

	override dispose() {
		if(image != null) {
			image.dispose()
		}

		super.dispose()
	}
}
