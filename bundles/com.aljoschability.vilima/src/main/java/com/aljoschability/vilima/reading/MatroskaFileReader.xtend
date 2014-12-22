package com.aljoschability.vilima.reading

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaFactory
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.attribute.BasicFileAttributeView
import org.eclipse.emf.common.util.URI

class MkFileReader {
	def MkFile read(URI uri) {
		createMkFile(Paths::get(uri.toFileString))
	}

	def MkFile createMkFile(Path path) {
		val seeker = new MatroskaFileSeeker(path)

		val file = path.toFile
		val attributes = Files::getFileAttributeView(path, BasicFileAttributeView).readAttributes

		val result = VilimaFactory::eINSTANCE.createMkFile
		result.name = file.name
		result.path = file.parent
		result.dateModified = attributes.lastModifiedTime.toMillis
		result.dateCreated = attributes.creationTime.toMillis
		result.size = attributes.size

		val builder = new MatroskaFileBuilder(seeker, result)

		seeker.readFile(builder)

		seeker.dispose()

		return result
	}
}
