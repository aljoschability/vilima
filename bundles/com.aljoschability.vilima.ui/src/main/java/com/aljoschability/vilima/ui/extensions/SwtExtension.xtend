package com.aljoschability.vilima.ui.extensions

import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Group

interface SwtExtension {
	val INSTANCE = new SwtExtensionImpl

	def GridData newGridData(boolean h, boolean v)

	def GridData newGridData()

	def GridLayout newGridLayout()

	def GridLayout newGridLayout(int columns)

	def GridLayout newGridLayoutSwt()

	def GridLayout newGridLayoutSwt(int columns)

	def Composite newComposite(Composite parent)

	def Group newGroup(Composite parent)
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

	override newGridLayoutSwt() {
		newGridLayoutSwt(1)
	}

	override newGridLayoutSwt(int columns) {
		GridLayoutFactory::swtDefaults.numColumns(columns).create
	}

	override newComposite(Composite parent) {
		new Composite(parent, SWT::NONE)
	}

	override newGroup(Composite parent) {
		new Group(parent, SWT::NONE)
	}

}
