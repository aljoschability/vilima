package com.aljoschability.vilima

import com.aljoschability.vilima.emf.MkResource
import org.eclipse.emf.common.util.URI
import org.junit.Test

class MkvResourceTests {
	val static PATH = '''C:\dev\repos\github.com\aljoschability\vilima\tests\data\track\ordering\test.mkv'''

	@Test
	def void testLoadMkvResource() {
		val uri = URI::createFileURI(PATH)

		val resource = new MkResource(uri)

		resource.load(null)
	}
}
