package com.aljoschability.vilima.jobs

import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.IProgressMonitor
import java.io.File
import java.util.Collection
import com.aljoschability.vilima.VilimaManager
import org.eclipse.core.runtime.Status
import java.nio.file.Paths
import java.nio.file.Files

class AddFilesJob extends Job {
	val VilimaManager manager
	val File root
	val Collection<File> files
	val boolean clear

	private new(VilimaManager manager, File root, Collection<File> files, boolean clear) {
		super(typeof(AddFilesJob).name)

		this.manager = manager
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
	new(VilimaManager manager, Collection<File> files, boolean clear) {
		this(manager, null, files, clear)
	}

	/**
	 * creates a new job that will add all files recursively starting on the given root directory and optionally clears all existing ones.
	 * it will only scan supported files distinguished by their file extension.
	 * 
	 * @param manager The vilima manager to use.
	 * @param root The root directory of the files.
	 * @param clear Whether to clear existing files.
	 */
	new(VilimaManager manager, File root, boolean clear) {
		this(manager, root, null, clear)
	}

	override protected run(IProgressMonitor monitor) {
		monitor.beginTask("Reading things!", IProgressMonitor::UNKNOWN)

		println('''manager=«manager»''')
		println('''root=«root»''')
		println('''files=«files»''')
		println('''clear=«clear»''')

		if(root != null && root.directory && files == null) {
			val walker = new VilimaFileWalker
			Files::walkFileTree(root.toPath, walker)
			for (file : walker.files) {
				manager.addFile(file.toString)
			}
		}

		monitor.done

		return Status::OK_STATUS
	}
}
