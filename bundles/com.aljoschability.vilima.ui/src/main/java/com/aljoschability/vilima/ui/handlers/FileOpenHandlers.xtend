package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.jobs.AddFilesJob
import com.aljoschability.vilima.services.VilimaService
import java.io.File
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.DirectoryDialog
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Shell

abstract class BaseFileDirectoryHandler {
	@Inject VilimaService service

	protected def void executeJob(Shell shell, boolean clear) {
		val dialog = new DirectoryDialog(shell)
		dialog.message = "the message"
		dialog.text = "Select Directory"

		val path = dialog.open
		if(path == null) {
			return
		}

		new AddFilesJob(service, new File(path), clear).schedule
	}
}

class FileOpenDirectoryHandler extends BaseFileDirectoryHandler {
	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		executeJob(shell, true)
	}
}

class FileAddDirectoryHandler extends BaseFileDirectoryHandler {
	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		executeJob(shell, false)
	}
}

abstract class BaseFileFilesHandler {
	@Inject VilimaService service

	protected def void executeJob(Shell shell, boolean clear) {
		val dialog = new FileDialog(shell, SWT::OPEN.bitwiseOr(SWT::MULTI))
		dialog.filterExtensions = #["*.mkv;*.mk3d;*.mka;*.mks", "*.*"]
		dialog.filterIndex = 0
		dialog.filterNames = #["Matroska Files", "All Files"]
		dialog.text = "Select Files"

		if(dialog.open == null) {
			return
		}

		val files = newArrayList
		for (name : dialog.fileNames) {
			files += new File(dialog.filterPath, name)
		}

		new AddFilesJob(service, files, clear).schedule
	}
}

class FileOpenFilesHandler extends BaseFileFilesHandler {
	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		executeJob(shell, true)
	}
}

class FileAddFilesHandler extends BaseFileFilesHandler {
	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SHELL) Shell shell) {
		executeJob(shell, false)
	}
}
