package com.aljoschability.vilima.jobs

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.VilimaFactory
import java.io.IOException
import java.nio.file.FileVisitResult
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.SimpleFileVisitor
import java.nio.file.attribute.BasicFileAttributes
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import com.aljoschability.vilima.reading.MatroskaReader

class VilimaScanJob extends Job {
	IContentManager manager

	Path path

	new(IContentManager manager, Path path) {
		super('''Scan Job for '«path»'...''')

		this.manager = manager
		this.path = path

		user = true
	}

	override protected run(IProgressMonitor monitor) {

		/*  val ticks = 6000;
      monitor.beginTask("Doing some work", ticks);
      try {
         for (var i=0;i<ticks;i++) {
            if (monitor.isCanceled()){
               return Status.CANCEL_STATUS;}
            monitor.subTask("Processing tick #" + i);
            //... do some work ...
            monitor.worked(1);
         }
      } finally {
         monitor.done();
      }
      return Status.OK_STATUS;
      */
		manager.clear();

		Files::walkFileTree(path, new VilimaFileWalker(manager))

		manager.refresh();

		val reader = new MatroskaReader()
		for (file : manager.content.files) {
			println('''reading «file.fileName»...''')
			reader.readFile(file)
		}

		manager.refresh();

		return Status::OK_STATUS
	}
}

class VilimaFileWalker extends SimpleFileVisitor<Path> {
	IContentManager manager

	new(IContentManager manager) {
		this.manager = manager
	}

	override visitFile(Path path, BasicFileAttributes attrs) throws IOException {
		if (path.toString.toLowerCase.endsWith(".mkv")) {
			val realFile = path.toFile

			val file = VilimaFactory::eINSTANCE.createMkvFile
			file.fileName = realFile.name
			file.filePath = realFile.parent
			file.fileDate = realFile.lastModified
			file.fileSize = realFile.length

			manager.add(file)
		}

		return FileVisitResult::CONTINUE
	}
}
