package com.aljoschability.vilima.ui.extensions

import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout

interface SwtExtension {
	val INSTANCE = new SwtExtensionImpl

	def GridData newGridData(boolean h, boolean v)

	def GridData newGridData()

	def GridLayout newGridLayout()

	def GridLayout newGridLayout(int columns)

	def GridLayout newSwtGridLayout()

	def GridLayout newSwtGridLayout(int columns)
}

class SwtExtensionImpl implements SwtExtension {
	override newGridData(boolean h, boolean v) {
		GridDataFactory::fillDefaults.grab(h, v).create
	}

	override newGridData() {
		newGridData(false, false)
	}

	override newGridLayout() {
		newGridLayout(1)
	}

	override newGridLayout(int columns) {
		GridLayoutFactory::fillDefaults.numColumns(columns).create
	}

	override newSwtGridLayout() {
		newSwtGridLayout(1)
	}

	override newSwtGridLayout(int columns) {
		GridLayoutFactory::swtDefaults.numColumns(columns).create
	}
}
