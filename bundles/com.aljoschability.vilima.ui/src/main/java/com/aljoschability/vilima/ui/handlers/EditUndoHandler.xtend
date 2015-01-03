package com.aljoschability.vilima.ui.handlers

import com.aljoschability.vilima.VilimaManager
import javax.inject.Named
import javax.inject.Provider
import org.eclipse.e4.core.di.annotations.CanExecute
import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.ui.basic.MPart
import org.eclipse.e4.ui.services.IServiceConstants

abstract class AbstractVilimaManagerHandler {
	@CanExecute
	def final boolean canExecute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		val object = part.object

		if(object instanceof Provider<?>) {
			val manager = object.get
			if(manager instanceof VilimaManager) {
				return canExecute(manager)
			}
		}
		return false
	}

	@Execute
	def final void execute(@Named(IServiceConstants::ACTIVE_PART) MPart part) {
		execute((part.object as Provider<?>).get as VilimaManager)
	}

	def protected boolean canExecute(VilimaManager manager)

	def protected void execute(VilimaManager manager)
}

class EditUndoHandler extends AbstractVilimaManagerHandler {
	override protected canExecute(VilimaManager manager) {
		true||manager.commandStack.canUndo
	}

	override protected execute(VilimaManager manager) {
		manager.commandStack.undo
	}
}

class EditRedoHandler extends AbstractVilimaManagerHandler {
	override protected canExecute(VilimaManager manager) {
		manager.commandStack.canRedo
	}

	override protected execute(VilimaManager manager) {
		manager.commandStack.redo
	}
}
