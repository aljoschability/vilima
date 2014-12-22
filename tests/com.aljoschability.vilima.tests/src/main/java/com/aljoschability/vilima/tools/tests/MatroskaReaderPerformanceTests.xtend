package com.aljoschability.vilima.tools.tests

import com.aljoschability.vilima.jobs.VilimaFileWalker
import com.aljoschability.vilima.reading.MkFileReader
import com.google.common.base.Stopwatch
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import java.util.Collection
import java.util.concurrent.TimeUnit
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.BeforeClass
import org.junit.Test

class MatroskaReaderPerformanceTests {
	val static PATH = Paths::get('''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files''')

	@BeforeClass
	def static void preload() {
		val p = '''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files\cover_art.mkv'''

		new MkFileReader().createMkFile(Paths::get(p))
		new ResourceSetImpl().getResource(URI::createFileURI(p), true).contents.get(0)
	}

	private static def Collection<File> getAllFiles() {
		val walker = new VilimaFileWalker
		Files::walkFileTree(PATH, walker)

		//new File(PATH).listFiles([p, n|n.endsWith(".mkv")])
		return walker.files
	}

	@Test
	def void testMkResource() {
		val files = allFiles

		val resourceSet = new ResourceSetImpl

		val watch = Stopwatch::createStarted
		for (file : files) {
			val uri = URI::createFileURI(file.toString)

			val r = resourceSet.getResource(uri, true)
			r.contents.get(0)
		}
		watch.stop

		println('''resource («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}

	@Test
	def void testMatroskaFileReader() {
		val files = allFiles

		val reader = new MkFileReader

		val watch = Stopwatch::createStarted
		for (file : files) {

			//println('''reading «file»...''')
			reader.createMkFile(file.toPath)
		}
		watch.stop

		println('''internal («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}

	@Test
	def void testMkvInfo() {
		val files = allFiles

		val watch = Stopwatch::createStarted
		for (file : files) {
			Runtime::getRuntime.exec('''mkvinfo "«file»"''').waitFor

		//println(file)
		}
		watch.stop

		println(''' mkvinfo («files.size»): «watch.elapsed(TimeUnit::MILLISECONDS)»ms''')
	}
}
