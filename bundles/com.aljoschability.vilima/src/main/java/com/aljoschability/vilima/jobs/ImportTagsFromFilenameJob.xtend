package com.aljoschability.vilima.jobs

import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.IProgressMonitor
import java.util.Collection
import java.io.File
import java.util.regex.Pattern
import com.aljoschability.vilima.VilimaFile

class ImportTagsFromFilenameJob extends Job {
	new(Collection<VilimaFile> files, String pattern) {
		super("import tags from file name")
	}

	override protected run(IProgressMonitor monitor) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def static void main(String[] args) {
		val path = new File('''C:\Repositories\arda.maglor\eclipse\vilima\__STUFF__\files''')
		val pattern1 = '''{show} S{season}E{episode} {title}'''
		val pattern2 = '''(.*) S(.*)E(.*) (.*)'''

		val pattern = Pattern::compile(pattern2)

		for (file : path.listFiles([p, n|n.endsWith(".mkv")])) {
			val matcher = pattern.matcher(file.name.substring(0, file.name.length - 4))

			if (matcher.matches) {
				println(file.name)
				for (var i = 1; i <= matcher.groupCount; i++) {
					println("   " + i + ": " + matcher.group(i))
				}
			}
		}
	}
}
