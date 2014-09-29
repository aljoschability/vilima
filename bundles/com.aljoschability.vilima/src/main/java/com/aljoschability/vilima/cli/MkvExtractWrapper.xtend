package com.aljoschability.vilima.cli

import java.io.File
import java.nio.file.Files

class MkvExtractWrapper {
	val String executable

	File file

	new(String executable) {
		this.executable = executable

		file = Files::createTempFile("vilima_extract", ".xml").toFile
		file.deleteOnExit
	}
}
