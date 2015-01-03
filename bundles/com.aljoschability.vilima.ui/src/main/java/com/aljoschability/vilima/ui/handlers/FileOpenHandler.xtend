package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute

class FileOpenHandler {
	static val PARAMETER_RECURSIVE = "com.aljoschability.vilima.commands.file.open.parameters.recursive"
	static val PARAMETER_ADD = "com.aljoschability.vilima.commands.file.open.parameters.add"

	@Execute
	def void execute(
		@Named(PARAMETER_ADD) String rawAdd,
		@Named(PARAMETER_RECURSIVE) String rawRecursive
	) {
		val isAdd = Boolean::parseBoolean(rawAdd)
		val isRecursive = Boolean::parseBoolean(rawRecursive)

		if(!isAdd) {
			println('''ask if changes should be stored and clear resources!''')
		}

		println('''add files (whole directory=«isRecursive»)''')
	}
}
