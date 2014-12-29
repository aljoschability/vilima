package com.aljoschability.vilima.ui.handlers

import javax.inject.Named
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.ui.basic.MPart
import org.eclipse.e4.ui.services.IServiceConstants
import com.aljoschability.vilima.VilimaManagerProvider
import com.aljoschability.vilima.VilimaManager

abstract class AbstractVilimaManagerHandler {
	@CanExecute
	def final boolean canExecute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		val object = part.object
		if(object instanceof VilimaManagerProvider) {
			return canExecute(object.vilimaManager)
		}

		return false
	}

	def protected boolean canExecute(VilimaManager manager)

	@Execute
	def final void execute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		execute((part.object as VilimaManagerProvider).vilimaManager)
	}

	def protected void execute(VilimaManager manager)
}

class EditUndoHandler extends AbstractVilimaManagerHandler {
	override protected canExecute(VilimaManager manager) {
		manager.editingDomain.commandStack.canUndo
	}

	override protected execute(VilimaManager manager) {
		manager.editingDomain.commandStack.undo
	}
}

class EditRedoHandler extends AbstractVilimaManagerHandler {
	override protected canExecute(VilimaManager manager) {
		manager.editingDomain.commandStack.canRedo
	}

	override protected execute(VilimaManager manager) {
		manager.editingDomain.commandStack.redo
	}
}
