package com.aljoschability.vilima.jobs

import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import java.util.List
import com.aljoschability.vilima.MkFile

class FindMovieTagDataJob extends Job {
	List<MkFile> files

	new(List<MkFile> files) {
		super("Find movie tag data")

		this.files = files
	}

	override protected run(IProgressMonitor monitor) {
		monitor.beginTask('''Finding movie tag data.''', IProgressMonitor::UNKNOWN)
		println('''Starting to search for movie tag data...''')

		for (file : files) {
			if(monitor.canceled) {
				return Status::CANCEL_STATUS
			}

			monitor.subTask('''Working on «file.name»''')
			println('''Working on «file.name»''')

			val tagIds = file.tagIdentifiers
			val tagTitle = file.tagTitle
			val segmentTitle = file.segmentTitle
			val fileTitle = file.fileTitle

			println('''tagIds=«tagIds»; tagTitle=«tagTitle»; segmentTitle=«segmentTitle»; fileTitle=«fileTitle»"''')
		}

		monitor.done

		return Status::OK_STATUS
	}

	def String getTagIdentifiers(MkFile file) {}

	def String getTagTitle(MkFile file) {}

	def String getSegmentTitle(MkFile file) {}

	def String getFileTitle(MkFile file) {}
}
