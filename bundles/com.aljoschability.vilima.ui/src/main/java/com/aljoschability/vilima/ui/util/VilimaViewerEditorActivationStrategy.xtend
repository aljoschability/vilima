package com.aljoschability.vilima.ui.util

import org.eclipse.jface.viewers.ColumnViewer
import org.eclipse.jface.viewers.ColumnViewerEditorActivationEvent
import org.eclipse.jface.viewers.ColumnViewerEditorActivationStrategy
import org.eclipse.jface.viewers.ViewerCell
import org.eclipse.jface.viewers.ViewerRow
import org.eclipse.jface.viewers.IStructuredSelection

class VilimaViewerEditorActivationStrategy extends ColumnViewerEditorActivationStrategy {
	ViewerRow previousRow

	new(ColumnViewer viewer) {
		super(viewer)
	}

	override protected isEditorActivationEvent(ColumnViewerEditorActivationEvent event) {

		// always activate on programmatic request
		if(event.eventType == ColumnViewerEditorActivationEvent.PROGRAMMATIC) {
			return true
		}

		// no activation on multiple selected elements
		if((viewer.selection as IStructuredSelection).size != 1) {
			return false
		}

		// activate only if row is already selected
		if(event.source instanceof ViewerCell) {
			val currentRow = (event.source as ViewerCell).viewerRow

			if(currentRow == previousRow) {
				return event.eventType == ColumnViewerEditorActivationEvent.TRAVERSAL ||
					event.eventType == ColumnViewerEditorActivationEvent.MOUSE_CLICK_SELECTION ||
					event.eventType == ColumnViewerEditorActivationEvent.MOUSE_DOUBLE_CLICK_SELECTION
			}

			previousRow = currentRow
		} else {
			previousRow = null
		}

		return false
	}
}
