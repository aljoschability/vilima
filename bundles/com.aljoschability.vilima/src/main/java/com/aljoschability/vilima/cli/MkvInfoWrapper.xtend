package com.aljoschability.vilima.cli

import java.nio.file.Files
import java.io.File

class MkvInfoWrapper {
	val String executable

	File file

	new(String executable) {
		this.executable = executable

		file = Files::createTempFile("vilima_info", ".txt").toFile
		file.deleteOnExit
	}
}
