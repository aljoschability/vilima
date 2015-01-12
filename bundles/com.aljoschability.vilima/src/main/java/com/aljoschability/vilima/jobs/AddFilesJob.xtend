package com.aljoschability.vilima.jobs

import com.aljoschability.vilima.Activator
import com.aljoschability.vilima.services.VilimaService
import java.io.File
import java.nio.file.AccessDeniedException
import java.nio.file.Files
import java.util.Collection
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job

class AddFilesJob extends Job {
	val VilimaService service
	val File root
	val Collection<File> files
	val boolean clear

	private new(VilimaService service, File root, Collection<File> files, boolean clear) {
		super(typeof(AddFilesJob).name)

		this.service = service
		this.root = root
		this.files = files
		this.clear = clear
	}

	/**
	 * creates a new job that will add all files in the given collection and optionally clear all existing ones.
	 * 
	 * @param manager The vilima manager to use.
	 * @param files The files to add.
	 * @param clear Whether to clear existing files.
	 */
	new(VilimaService service, Collection<File> files, boolean clear) {
		this(service, null, files, clear)
	}

	/**
	 * creates a new job that will add all files recursively starting on the given root directory and optionally clears all existing ones.
	 * it will only scan supported files distinguished by their file extension.
	 * 
	 * @param manager The vilima manager to use.
	 * @param root The root directory of the files.
	 * @param clear Whether to clear existing files.
	 */
	new(VilimaService service, File root, boolean clear) {
		this(service, root, null, clear)
	}

	override protected run(IProgressMonitor monitor) {
		monitor.beginTask("Reading things!", IProgressMonitor::UNKNOWN)

		println('''manager=«service»''')
		println('''root=«root»''')
		println('''files=«files»''')
		println('''clear=«clear»''')

		if(root != null && root.directory && files == null) {
			val walker = new VilimaFileWalker
			try {
				Files::walkFileTree(root.toPath, walker)
			} catch(AccessDeniedException e) {
				Activator::get.warn('''[AddFilesJob] Access denied for something. Aborting.''')
			}

			// add collected files
			for (file : walker.files) {
				service.addFile(file.toString)
			}
		}

		monitor.done

		return Status::OK_STATUS
	}
}
