package com.aljoschability.vilima.ui.widgets

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

	def String getMessage() { message }
}
