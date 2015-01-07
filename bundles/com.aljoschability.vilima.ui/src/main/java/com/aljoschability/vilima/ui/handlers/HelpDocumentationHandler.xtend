package com.aljoschability.vilima.ui.handlers

import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.swt.program.Program

class HelpDocumentationHandler {
	static val URI = '''https://www.aljoschability.com/projects/vilima/'''

	@Execute
	def void execute() { Program::launch(URI) }
}
