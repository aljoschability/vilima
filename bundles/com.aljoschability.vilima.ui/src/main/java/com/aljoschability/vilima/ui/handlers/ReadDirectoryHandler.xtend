package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.jobs.VilimaScanJob
import java.nio.file.Paths
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.ui.basic.MWindow
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.swt.widgets.DirectoryDialog
import org.eclipse.swt.widgets.Shell

class ReadDirectoryHandler {
	@Inject IContentManager manager

	@Execute
	def execute(MWindow window, @Named(IServiceConstants.ACTIVE_SHELL) Shell shell) {
		val dialog = new DirectoryDialog(shell)
		dialog.text = "Directory Selection"
		dialog.message = "Select the directory containing the video files."
		dialog.filterPath = '''C:\Repositories\arda.maglor\eclipse\vilima\__STUFF__\files'''

		// check whether something should be read
		val path = dialog.open
		if (path == null) {
			return true
		}

		// check whether path has been changed
		if (manager.path == path) {
			return true
		}

		window.label = '''Vilima - «path»'''

		new VilimaScanJob(manager, Paths::get(path)).schedule

		return true
	}
}
