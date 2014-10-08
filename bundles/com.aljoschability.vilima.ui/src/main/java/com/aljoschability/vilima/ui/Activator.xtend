package com.aljoschability.vilima.ui;

import com.aljoschability.core.ui.runtime.AbstractActivator
import com.aljoschability.core.ui.runtime.IActivator

final class Activator extends AbstractActivator {
	static IActivator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {
		Activator::INSTANCE = this

		addImage(VilimaImages::TRACK_TYPE_VIDEO)
		addImage(VilimaImages::TRACK_TYPE_AUDIO)
		addImage(VilimaImages::TRACK_TYPE_SUBTITLE)

	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
