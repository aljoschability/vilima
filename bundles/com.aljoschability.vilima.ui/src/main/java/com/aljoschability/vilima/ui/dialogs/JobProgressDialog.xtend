package com.aljoschability.vilima.ui.dialogs;

import org.eclipse.jface.dialogs.ProgressMonitorDialog
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Shell

class JobProgressDialog extends ProgressMonitorDialog {
	new(Shell parent) {
		super(parent)
	}

	override protected createDialogArea(Composite parent) {
		val composite = super.createDialogArea(parent)

		return composite
	}
}
