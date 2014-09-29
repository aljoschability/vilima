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

		addImage(MalimarImages::FILE)

		addImage(MalimarImages::FLAG_UNDEFINED)
		addImage(MalimarImages::FLAG_EN)
		addImage(MalimarImages::FLAG_DE)

		addImage(MalimarImages::TRACK_AUDIO)
		addImage(MalimarImages::TRACK_TEXT)
		addImage(MalimarImages::TRACK_VIDEO)
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}
}
