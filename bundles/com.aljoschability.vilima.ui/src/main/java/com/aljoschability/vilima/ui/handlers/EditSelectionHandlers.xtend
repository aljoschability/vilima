package com.aljoschability.vilima.ui.handlers

import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute

class EditSelectAllHandler {
	@CanExecute
	def boolean canExecute() {
		true
	}

	@Execute
	def void execute() {
		println('''select all''')
	}
}

class EditInvertSelectionHandler {
	@CanExecute
	def boolean canExecute() {
		true
	}

	@Execute
	def void execute() {
		println('''invert selection''')
	}
}
