package com.aljoschability.vilima.writing.tests

import com.aljoschability.vilima.reading.MkFileReader
import com.aljoschability.vilima.writing.ChapterWriter
import java.nio.file.Paths
import org.junit.Test

import static org.junit.Assert.*

class ChaptersWriterTests {
	val static ROOT = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files'''

	val static READER = new MkFileReader

	@Test
	def void testEmptyChapters() {
		val writer = new ChapterWriter

		val path = Paths::get(ROOT, "_proptest.mkv")
		val file = READER.createMkFile(path)

		assertTrue(writer.write(file))
	}

	@Test
	def void testExistingChapters() {
		val writer = new ChapterWriter

		val path = Paths::get(ROOT, "Game of Thrones S02E03 What is Dead May Never Die.mkv")
		val file = READER.createMkFile(path)

		assertTrue(writer.write(file))
	}
}
