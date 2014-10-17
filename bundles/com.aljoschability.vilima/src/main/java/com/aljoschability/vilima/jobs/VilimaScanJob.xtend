package com.aljoschability.vilima.jobs

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.reading.MatroskaReader
import java.io.File
import java.io.IOException
import java.nio.file.FileVisitResult
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.SimpleFileVisitor
import java.nio.file.attribute.BasicFileAttributes
import java.text.NumberFormat
import java.util.Collection
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job

class VilimaScanJob extends Job {
	static val DEBUG_NF = NumberFormat::getNumberInstance

	IContentManager manager

	Path path

	new(IContentManager manager, Path path) {
		super("Scanning Files")

		this.manager = manager
		this.path = path

		// TODO: debug
		DEBUG_NF.setMinimumFractionDigits(2);
		DEBUG_NF.setMaximumFractionDigits(2);

		user = true
	}

	override protected run(IProgressMonitor monitor) {

		// TODO: use progress monitor
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

		val walker = new VilimaFileWalker

		Files::walkFileTree(path, walker)

		val library = manager.library

		val reader = new MatroskaReader(library)
		for (file : walker.files) {
			val started = System.nanoTime();

			manager.add(reader.readFile(file.toPath))

			// TODO: debug
			val elapsed = DEBUG_NF.format((System.nanoTime() - started) / 1000000d);
			println('''«elapsed»ms needed for "«file.name»".''');
		}

		manager.refresh();

		//		manager.refresh();
		return Status::OK_STATUS
	}
}

class VilimaFileWalker extends SimpleFileVisitor<Path> {
	val Collection<File> files

	new() {
		files = newArrayList()
	}

	override visitFile(Path path, BasicFileAttributes attrs) throws IOException {
		val file = path.toFile
		if (file.name.toLowerCase.endsWith(".mkv")) {
			files += file
		}

		return FileVisitResult::CONTINUE
	}

	def Collection<File> getFiles() {
		return files
	}
}
