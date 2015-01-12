package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.VilimaManager
import com.aljoschability.vilima.jobs.AddFilesJob
import java.io.File
import org.eclipse.swt.widgets.DirectoryDialog
import org.eclipse.swt.SWT

class xFileAddHandler extends AbstractVilimaManagerHandler {
	override protected canExecute(VilimaManager manager) {
		true
	}

	override protected execute(VilimaManager manager) {
		val root = new File('''C:\dev\repos\github.com\aljoschability\vilima\__TODO\files''')

		val shell = null
		val d = new DirectoryDialog(shell, SWT::OPEN)

		println("xFileAddHandler: did not start job!")

	//new AddFilesJob(manager, root, true).schedule()
	}
}
