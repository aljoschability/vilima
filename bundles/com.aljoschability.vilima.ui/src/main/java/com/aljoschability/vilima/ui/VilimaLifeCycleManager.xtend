package com.aljoschability.vilima.ui

import com.aljoschability.vilima.IContentManager
import com.aljoschability.vilima.VilimaContentManager
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import javax.inject.Inject
import org.eclipse.e4.core.contexts.IEclipseContext
import org.eclipse.e4.core.services.events.IEventBroker
import org.eclipse.e4.ui.workbench.lifecycle.PostContextCreate

class VilimaLifeCycleManager {
	@Inject IEventBroker broker

	@PostContextCreate
	def postContextCreate(IEclipseContext context) {
		val columnRegistry = new MkFileColumnRegistry
		context.set(MkFileColumnRegistry, columnRegistry)

		Activator::get.registerColumnExtensionImages(columnRegistry)

		context.set(IContentManager, new VilimaContentManager(broker))
	}
}
