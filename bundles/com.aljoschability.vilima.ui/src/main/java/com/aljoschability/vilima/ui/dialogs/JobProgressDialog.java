package com.aljoschability.vilima.ui.dialogs;

import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Shell;

/**
 * @see org.eclipse.ui.internal.progress.ProgressMonitorFocusJobDialog
 */
public class JobProgressDialog extends ProgressMonitorDialog {
	public JobProgressDialog(Shell parent) {
		super(parent);
	}

	@Override
	protected Control createDialogArea(Composite parent) {
		Control composite = super.createDialogArea(parent);

		return composite;
	}
}
