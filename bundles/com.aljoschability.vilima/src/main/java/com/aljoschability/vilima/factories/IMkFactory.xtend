package com.aljoschability.vilima.factories

import java.nio.file.Path
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkAttachment
import java.nio.file.Files
import java.nio.file.attribute.BasicFileAttributeView

interface IMkFactory {
	def MkFile createFile(Path path)

	def MkAttachment createAttachment(long uid, String name, String mimeType, long size, String description)

	def MkChapter createChapter(long uid, long start, boolean flagEnabled, boolean flagHidden)

	def MkChapterText createChapterText(String text)

	def MkEdition createEdition(long uid, boolean flagDefault, boolean flagHidden)

}

class MkFactoryImpl implements IMkFactory {
	val f = VilimaFactory::eINSTANCE

	override createFile(Path path) {
		val file = path.toFile

		val mkv = f.createMkFile

		mkv.path = file.parent
		mkv.name = file.name

		val attributes = Files::getFileAttributeView(path, BasicFileAttributeView).readAttributes
		mkv.dateModified = attributes.lastModifiedTime.toMillis
		mkv.dateCreated = attributes.creationTime.toMillis
		mkv.size = attributes.size

		return mkv
	}

	override createAttachment(long uid, String name, String mimeType, long size, String description) {
		val result = f.createMkAttachment

		result.uid = uid
		result.name = name
		result.mimeType = mimeType
		result.size = size
		result.description = description

		return result
	}

	override createChapter(long uid, long start, boolean flagEnabled, boolean flagHidden) {
		val result = f.createMkChapter

		result.uid = uid
		result.start = start
		result.flagEnabled = flagEnabled
		result.flagHidden = flagHidden

		return result
	}

	override createChapterText(String text) {
		val result = f.createMkChapterText

		result.text = text

		return result
	}

	override createEdition(long uid, boolean flagDefault, boolean flagHidden) {
		val result = f.createMkEdition

		result.uid = uid
		result.flagDefault = flagDefault
		result.flagHidden = flagHidden

		return result
	}

}
