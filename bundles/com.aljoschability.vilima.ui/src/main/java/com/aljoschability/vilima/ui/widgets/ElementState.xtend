package com.aljoschability.vilima.ui.widgets

import com.aljoschability.core.ui.CoreImages
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.graphics.Color
import com.aljoschability.core.ui.CoreColors

class ElementState {
	public static val INFORMATION = 0
	public static val WARNING = 1
	public static val ERROR = 2

	def static ElementState newInformation(String message) {
		new ElementState(INFORMATION, message)
	}

	def static ElementState newWarning(String message) {
		new ElementState(WARNING, message)
	}

	def static ElementState newError(String message) {
		new ElementState(ERROR, message)
	}

	val int severity
	val String message

	new(int severity, String message) {
		this.severity = severity
		this.message = message
	}

	def Image getImage() {
		switch severity {
			case ElementState::INFORMATION: CoreImages::get(CoreImages::STATE_INFORMATION)
			case ElementState::WARNING: CoreImages::get(CoreImages::STATE_INFORMATION)
			case ElementState::ERROR: CoreImages::get(CoreImages::STATE_INFORMATION)
			default: null
		}
	}

	def Color getColor() {
		switch severity {
			case ElementState::WARNING: CoreColors::get(CoreColors::WARNING)
			case ElementState::ERROR: CoreColors::get(CoreColors::ERROR)
			default: null
		}
	}

	def String getMessage() { message }
}
