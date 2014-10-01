package com.aljoschability.vilima.ui

final class MalimarImages {

	def static image(String key) {
		Activator::get.getImage(key)
	}

	def static descriptor(String key) {
		Activator::get.getImageDescriptor(key)
	}
}
