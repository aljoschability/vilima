package com.aljoschability.vilima.jobs

import com.aljoschability.vilima.IContentManager
import java.io.IOException
import java.nio.file.FileVisitResult
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.SimpleFileVisitor
import java.nio.file.attribute.BasicFileAttributes
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import com.aljoschability.vilima.VilimaFactory

class VilimaScanJob extends Job {
	IContentManager manager

	Path path

	new(IContentManager manager, Path path) {
		super('''Scan Job for '«path»'...''')

		this.manager = manager
		this.path = path
	}

	override protected run(IProgressMonitor monitor) {
		Files::walkFileTree(path, new VilimaFileWalker(manager))

		return Status::OK_STATUS
	}
}

class VilimaFileWalker extends SimpleFileVisitor<Path> {
	IContentManager manager

	new(IContentManager manager) {
		this.manager = manager
	}

	override visitFile(Path path, BasicFileAttributes attrs) throws IOException {
		val realFile = path.toFile

		val file = VilimaFactory::eINSTANCE.createMkvFile
		file.fileName = realFile.name
		file.filePath = path.parent.toString
		file.fileDate = realFile.lastModified
		file.fileSize = realFile.length

		manager.add(file)

		return FileVisitResult::CONTINUE
	}
}
