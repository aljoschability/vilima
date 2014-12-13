package com.aljoschability.vilima.tools.tests

import com.aljoschability.vilima.reading.MatroskaFileReader
import com.google.common.base.Stopwatch
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.util.concurrent.TimeUnit
import org.junit.Test
import com.google.common.io.CharStreams
import org.junit.BeforeClass
import java.nio.file.Paths

class MatroskaReaderPerformanceTests {
	static val PATH = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files\attachments\multiattachmenttest (1).mkv'''

	@BeforeClass
	def static void preload() {
		new MatroskaFileReader().readFile(Paths::get(PATH))
	}

	@Test
	def void testMkvInfo() {
		val file = new File(PATH)

		val command = '''mkvinfo "«file»"'''

		println('''running the following command line:''')
		println(command)
		println('''result:''')

		val watch = Stopwatch::createStarted
		val process = Runtime::getRuntime.exec(command)
		if(process.waitFor == 0) {
			val is = new BufferedReader(new InputStreamReader(process.inputStream))

			println(CharStreams::toString(is))

			println('''needed «watch.stop.elapsed(TimeUnit::MILLISECONDS)»ms for mkvinfo''')
		}
	}

	@Test
	def void testMatroskaFileReader() {
		val reader = new MatroskaFileReader

		val watch = Stopwatch::createStarted
		reader.readFile(Paths::get(PATH))
		println('''needed «watch.stop.elapsed(TimeUnit::MILLISECONDS)»ms for MatroskaFileReader''')
	}
}
