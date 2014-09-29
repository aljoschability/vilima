package com.aljoschability.vilima

import java.nio.file.Files
import java.nio.file.Path

interface IVilimaManager {
	def void dispose()

	def Path getCachePath()
}

class VilimaManagerImpl implements IVilimaManager {
	def static void main(String[] args) {
		val m = new VilimaManagerImpl

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
