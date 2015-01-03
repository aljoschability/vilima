package com.aljoschability.vilima.ui.handlers

import java.util.Collection
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.jface.viewers.IStructuredSelection

class FileSaveAllHandler {
	@CanExecute
	def boolean canExecute(@Named(IServiceConstants::ACTIVE_SELECTION) IStructuredSelection selection) {
		return !selection.resources.nullOrEmpty
	}

	@Execute
	def void execute(@Named(IServiceConstants::ACTIVE_SELECTION) IStructuredSelection selection) {
		for (resource : selection.resources) {
			resource.save(null)
		}
	}

	@Deprecated
	def Collection<Resource> getResources(IStructuredSelection selection) {
		if(selection == null || selection.empty) {
			return null
		}

		val resources = newArrayList
		for (element : selection.toList) {
			if(element instanceof EObject) {
				val resource = element.eResource
				if(resource != null && resource.modified) {
					resources += resource
				}
			}
		}
		return resources
	}
}
