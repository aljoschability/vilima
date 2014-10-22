package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkFile
import javax.inject.Inject
import com.aljoschability.vilima.VilimaFactory
import java.nio.file.Path
import org.eclipse.core.runtime.IProgressMonitor
import com.aljoschability.vilima.MkTagEntry

interface VilimaCreator {
	def MkFile createMkFile(Path path, IProgressMonitor monitor)
}

interface VilimaProvider {

	def void create(MkFile file)

	def void write(MkFile file)

	def void read(MkFile file)
}

class VilimaProviderTests {
	@Inject extension VilimaCreator creator

	def void testRead(Path path) {
		val IProgressMonitor monitor = null
		VilimaFactory::eINSTANCE.createMkFile

		path.createMkFile(monitor)
	}
}
