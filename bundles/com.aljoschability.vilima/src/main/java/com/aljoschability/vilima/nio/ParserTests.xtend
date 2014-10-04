package com.aljoschability.vilima.nio

import java.nio.file.Paths

class ParserTests {
	def static void main(String[] args) {
		val path = '''C:\Repositories\arda.maglor\eclipse\vilima\__STUFF__\tests\file.mkv'''

		val reader = new Parser();

		reader.parse(Paths::get(path))
	}
}
