package com.aljoschability.vilima.ui.handlers

import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute

class EditCutHandler {
	@CanExecute
	def boolean canExecute() {
		true
	}

	@Execute
	def void execute() {
		println('''cut''')
	}
}

class EditCopyHandler {
	@CanExecute
	def boolean canExecute() {
		true
	}

	@Execute
	def void execute() {
		println('''copy''')
	}
}

class EditPasteHandler {
	@CanExecute
	def boolean canExecute() {
		true
	}

	@Execute
	def void execute() {
		println('''paste''')
	}
}
