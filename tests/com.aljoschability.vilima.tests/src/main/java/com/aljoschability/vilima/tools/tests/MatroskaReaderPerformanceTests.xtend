package com.aljoschability.vilima.tools.tests

import com.aljoschability.vilima.reading.MkFileReader
import com.google.common.base.Stopwatch
import java.io.File
import java.nio.file.Paths
import java.util.concurrent.TimeUnit
import org.junit.BeforeClass
import org.junit.Test

class MatroskaReaderPerformanceTests {
	static val PATH = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files\'''

	@BeforeClass
	def static void preload() {
		new MkFileReader().createMkFile(Paths::get(PATH, "cover_art.mkv"))
	}

	@Test
	def void testMkvInfo() {
		val files = new File(PATH).listFiles([p, n|n.endsWith(".mkv")])

		val watch = Stopwatch::createStarted
		for (file : files) {
			Runtime::getRuntime.exec('''mkvinfo "«file»"''').waitFor
		}
		watch.stop

		println(''' mkvinfo («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}

	@Test
	def void testMatroskaFileReader() {
		val files = new File(PATH).listFiles([p, n|n.endsWith(".mkv")])

		val reader = new MkFileReader

		val watch = Stopwatch::createStarted
		for (file : files) {
			reader.createMkFile(file.toPath)
		}
		watch.stop

		println('''internal («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}
}
