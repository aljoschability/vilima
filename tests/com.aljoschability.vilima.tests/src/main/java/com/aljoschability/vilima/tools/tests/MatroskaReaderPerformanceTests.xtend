package com.aljoschability.vilima.tools.tests

import com.aljoschability.vilima.reading.MkFileReader
import com.google.common.base.Stopwatch
import java.io.File
import java.nio.file.Paths
import java.util.concurrent.TimeUnit
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.BeforeClass
import org.junit.Test
import com.aljoschability.vilima.emf.MkResourceFactory

class MatroskaReaderPerformanceTests {
	static val PATH = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files\'''

	@BeforeClass
	def static void preload() {
		new MkFileReader().createMkFile(Paths::get(PATH, "cover_art.mkv"))
		new ResourceSetImpl().getResource(URI::createFileURI(Paths::get(PATH, "cover_art.mkv").toString), true)
	}

	@Test
	def void testMkResource() {
		val files = new File(PATH).listFiles([p, n|n.endsWith(".mkv")])

		val resourceSet = new ResourceSetImpl

		val watch = Stopwatch::createStarted
		for (file : files) {
			val uri = URI::createFileURI(file.toString)

			val r = resourceSet.getResource(uri, true)

			println(r.contents.get(0))
		}
		watch.stop

		println('''resource («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}

	@Test
	def void testMkvInfo() {
		val files = new File(PATH).listFiles([p, n|n.endsWith(".mkv")])

		val watch = Stopwatch::createStarted
		for (file : files) {
			Runtime::getRuntime.exec('''mkvinfo "«file»"''').waitFor

		//println(file)
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
			val mkFile = reader.createMkFile(file.toPath)

		//println(mkFile)
		}
		watch.stop

		println('''internal («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}
}
