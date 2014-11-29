package com.aljoschability.vilima.tools.tests

import com.aljoschability.vilima.ext.FileExtensions
import org.junit.Test

class FileExensionsTests {
	extension FileExtensions = FileExtensions::INSTANCE

	@Test
	def void testAsFileName() {
		var text = '''This? No That: There should be "NO" \ or / in a file name.'''

		println(text)
		println(text.asFileName)

		text = '''":/\?*|<>'''
		println(text)
		println(text.asFileName)

		text = " xxx "
		println(text)
		println(text.asFileName)
	}
}
