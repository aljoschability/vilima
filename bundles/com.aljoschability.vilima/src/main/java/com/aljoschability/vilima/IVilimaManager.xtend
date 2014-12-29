package com.aljoschability.vilima

import java.nio.file.Files
import java.nio.file.Path

@Deprecated
interface IVilimaManager {
	def void dispose()

	def Path getCachePath()
}

class XVilimaManagerImpl implements IVilimaManager {
	def static void main(String[] args) {
		val m = new XVilimaManagerImpl

		m.cachePath
	}

	override dispose() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getCachePath() {
		val dirPath = Files::createTempDirectory("vilima")

		val dir = dirPath.toFile
		dir.deleteOnExit

		val file = Files::createTempFile("vilima_tags_", ".xml").toFile
		file.delete

		println(file)

		return dirPath
	}
}
