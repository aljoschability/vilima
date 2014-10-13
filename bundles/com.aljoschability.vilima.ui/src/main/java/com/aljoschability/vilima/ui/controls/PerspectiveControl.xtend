package com.aljoschability.vilima.ui.controls

import javax.annotation.PostConstruct
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite

class PerspectiveControl {
	@PostConstruct def void createControl(Composite parent) {
		val spacer = new Composite(parent, SWT::NONE)
		spacer.setSize(100, 1)
	}
}
