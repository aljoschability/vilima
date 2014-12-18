package com.aljoschability.vilima.writing

import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.google.common.base.Charsets
import com.google.common.io.CharStreams
import com.google.common.io.Files
import java.io.InputStreamReader
import java.nio.file.Paths
import java.util.concurrent.TimeUnit

class ChapterWriter {
	val static DEBUG = true

	def boolean write(MkFile file) {
		val mkFile = Paths::get(file.path, file.name)
		val content = file.chapterFileContent

		var String command = null
		if(content == null) {
			command = '''mkvpropedit "«mkFile»" --chapters ""'''
		} else {
			val chapterFile = mkFile.parent.resolve(file.name + ".chapters.xml")
			Files::write(content, chapterFile.toFile, Charsets::UTF_8)
			command = '''mkvpropedit "«mkFile»" --chapters "«chapterFile»"'''
		}

		return command.execute
	}

	def static private boolean execute(String command) {
		if(DEBUG) {
			println(command)
		}

		val process = Runtime::getRuntime.exec(command)
		if(process.waitFor != 0) {
			val message = CharStreams::toString(new InputStreamReader(process.inputStream))

			//Activator::get.error(message)
			if(DEBUG) {
				println(message)
			}

			return false
		}

		if(DEBUG) {
			println(CharStreams::toString(new InputStreamReader(process.inputStream)))
		}

		return true
	}

	def private static String chapterFileContent(MkFile file) {
		if(file.editions.empty) {
			return null
		}

		var content = new StringBuilder

		content.appendHeader

		content.appendLine('''<Chapters>''', 0)
		for (edition : file.editions) {
			content.appendEdition(edition)
		}
		content.appendLine('''</Chapters>''', 0)

		return content.toString
	}

	def private static void appendLine(StringBuilder builder, String line, int indent) {
		for (var i = 0; i < indent; i++) {
			builder.append("\t")
		}
		builder.append(line)
		builder.append("\n")
	}

	def private static void appendHeader(StringBuilder content) {
		content.appendLine('''﻿<?xml version="1.0"?>''', 0)
		content.appendLine('''<!-- <!DOCTYPE Chapters SYSTEM "matroskachapters.dtd"> -->''', 0)
	}

	def private static void appendEdition(StringBuilder content, MkEdition edition) {
		content.appendLine('''<EditionEntry>''', 1)
		content.appendLine('''<EditionUID>«edition.uid»</EditionUID>''', 2)
		content.appendLine('''<EditionFlagDefault>«edition.flagDefault.toInteger»</EditionFlagDefault>''', 2)
		content.appendLine('''<EditionFlagHidden>«edition.flagHidden.toInteger»</EditionFlagHidden>''', 2)

		for (chapter : edition.chapters) {
			content.appendChapter(chapter)
		}
		content.appendLine('''</EditionEntry>''', 1)
	}

	def private static void appendChapter(StringBuilder content, MkChapter chapter) {
		content.appendLine('''<ChapterAtom>''', 2)
		content.appendLine('''<ChapterUID>«chapter.uid»</ChapterUID>''', 3)
		content.appendLine('''<ChapterFlagHidden>«chapter.flagHidden.toInteger»</ChapterFlagHidden>''', 3)
		content.appendLine('''<ChapterFlagEnabled>«chapter.flagEnabled.toInteger»</ChapterFlagEnabled>''', 3)
		for (text : chapter.texts) {
			content.appendChapterDisplay(text)
		}
		content.appendLine('''<ChapterTimeStart>«chapter.timeStart.toTime»</ChapterTimeStart>''', 3)
		content.appendLine('''</ChapterAtom>''', 2)
	}

	def private static void appendChapterDisplay(StringBuilder content, MkChapterText text) {
		content.appendLine('''<ChapterDisplay>''', 3)
		content.appendLine('''<ChapterString>«text.text»</ChapterString>''', 4)
		for (language : text.languages) {
			content.appendLine('''<ChapterLanguage>«language»</ChapterLanguage>''', 4)
		}
		content.appendLine('''</ChapterDisplay>''', 3)
	}

	def private static int toInteger(boolean value) {
		if(value) {
			return 1
		}
		return 0
	}

	def private static String toTime(Long time) {
		val text = new StringBuilder

		// hours
		val hours = TimeUnit::NANOSECONDS.toHours(time)
		if(hours < 10) {
			text.append("0")
		}
		text.append(hours)

		// minutes
		text.append(":")
		val minutes = TimeUnit::NANOSECONDS.toMinutes(time) % 60
		if(minutes < 10) {
			text.append("0")
		}
		text.append(minutes)

		// seconds
		text.append(":")
		val seconds = TimeUnit::NANOSECONDS.toSeconds(time) % 60
		if(seconds < 10) {
			text.append("0")
		}
		text.append(seconds)

		// nanos
		text.append(".")
		val ns = time % 1000000000
		text.append(String::format("%09d", ns))

		return text.toString
	}
}
