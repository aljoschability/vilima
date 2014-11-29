package com.aljoschability.vilima.ext

import java.text.Normalizer

interface FileExtensions {
	val FileExtensions INSTANCE = new FileExtensionsImpl

	def String asFileName(String text)
}

class FileExtensionsImpl implements FileExtensions {
	override asFileName(String text) {
		text.replaceInvalids.trimDuplicates.trimUnusual
	}

	def private static String replaceInvalids(String text) {
		text.replace('"', '\'').replace(':', '').replace('/', '-').replace('\\', '-').replace('?', '.').replace('*', '.').
			replace('|', '.').replace('<', '(').replace('>', ')')
	}

	def private static String withoutUnicode(String text) {
		Normalizer::normalize(text, Normalizer.Form::NFD).replaceAll('''\p{InCombiningDiacriticalMarks}|[^\w\s]''', "")
	}

	def private static String trimDuplicates(String text) {
		text.replaceAll('''[\s]+''', " ")
	}

	def private static String trimUnusual(String text) {
		text.trim('.').trim
	}

	def private static String trim(String text, char c) {
		var start = 0
		var end = text.length

		while(start < end && text.charAt(start) == c) {
			start++
		}

		while(start < end && text.charAt(end - 1) == c) {
			end--
		}

		if(start > 0 || end < text.length) {
			return text.substring(start, end)
		}

		return text
	}
}
