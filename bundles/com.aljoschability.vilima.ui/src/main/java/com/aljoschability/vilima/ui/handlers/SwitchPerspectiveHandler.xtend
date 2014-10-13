package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.MApplication
import org.eclipse.e4.ui.model.application.ui.advanced.MPerspective
import org.eclipse.e4.ui.workbench.modeling.EModelService
import org.eclipse.e4.ui.workbench.modeling.EPartService
import javax.inject.Inject

class SwitchPerspectiveHandler {
	static val PERSPECTIVE = "com.aljoschability.vilima.parameters.perspective"

	@Inject MApplication application
	@Inject EPartService partService
	@Inject EModelService modelService

	@Execute def void execute(@Named(PERSPECTIVE) String id) {
		val perspective = modelService.find(id, application) as MPerspective

		if (perspective != null) {
			partService.switchPerspective(perspective)
		} else {
			println('''{LOG} [WARN] perspective with id="«id»" not found!''')
		}
	}
}
