package com.aljoschability.vilima.ui

import org.eclipse.e4.ui.workbench.lifecycle.PostContextCreate
import org.eclipse.e4.core.contexts.IEclipseContext
import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.VilimaContentManager
import javax.inject.Inject
import org.eclipse.e4.core.services.events.IEventBroker

class VilimaLifeCycleManager {
	@Inject IEventBroker broker

	@PostContextCreate
	def postContextCreate(IEclipseContext context) {
		context.set(IContentManager, new VilimaContentManager(broker))
	}
}
