package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkFile
import java.io.File
import java.nio.file.Paths

interface MkFileExtension {
	val MkFileExtension INSTANCE = new MkFileExtensionImpl

	def File toFile(MkFile file)
}

class MkFileExtensionImpl implements MkFileExtension {
	override toFile(MkFile file) {
		Paths::get(file.path, file.name).toFile
	}
}
