package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.VilimaManager
import java.util.Collection
import javax.inject.Named
import javax.inject.Provider
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.ui.basic.MPart
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.emf.ecore.resource.Resource

class FileSaveHandler {
	@CanExecute
	def boolean canExecute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		return !part.resources.nullOrEmpty
	}

	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		for (resource : part.resources) {
			resource.save(null)
		}
	}

	@Deprecated
	def Collection<Resource> getResources(MPart part) {
		val resourceSet = part?.manager?.resourceSet
		if(resourceSet == null) {
			return null
		}

		val resources = newArrayList
		for (resource : resourceSet.resources) {
			if(resource.modified) {
				resources += resource
			}
		}
		return resources
	}

	@Deprecated
	def VilimaManager getManager(MPart part) {
		val object = part.object

		if(object instanceof Provider<?>) {
			val manager = object.get
			if(manager instanceof VilimaManager) {
				manager
			}
		}
	}
}
