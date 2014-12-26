package com.aljoschability.vilima.ui.extensions

import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.Viewer
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.Tree
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import org.eclipse.swt.widgets.Table
import org.eclipse.jface.viewers.TableViewer

class SwtExtension {
	val public static INSTANCE = new SwtExtension

	def boolean isActive(Control control) { control != null && !control.disposed }

	def boolean isActive(Viewer viewer) { viewer != null && viewer.control.active }

	def SashForm newSashForm(Composite parent, int style, Procedure1<SashForm> function) {
		val result = new SashForm(parent, style)
		function.apply(result)
		return result
	}

	def Label newLabel(Composite parent, int style, Procedure1<Label> function) {
		val result = new Label(parent, style)
		function.apply(result)
		return result
	}

	def Combo newCombo(Composite parent, int style, Procedure1<Combo> function) {
		val result = new Combo(parent, style)
		function.apply(result)
		return result
	}

	def Composite newComposite(Composite parent, Procedure1<Composite> function) {
		val result = new Composite(parent, SWT::NONE)
		function.apply(result)
		return result
	}

	def Group newGroup(Composite parent, Procedure1<Group> function) {
		val result = new Group(parent, SWT::NONE)
		function.apply(result)
		return result
	}

	def Table newTable(Composite parent, int style, Procedure1<Table> function) {
		val result = new Table(parent, style)
		function.apply(result)
		return result
	}

	def private int flagged(int... values) {
		var value = SWT::NONE

		for (style : values) {
			value = value.bitwiseOr(style)
		}

		return value
	}

	def TableViewer newTableViewer(Composite parent, Procedure1<TableViewer> procedure, int... style) {
		val viewer = new TableViewer(parent, style.flagged)
		procedure.apply(viewer)
		return viewer
	}

	def Tree newTree(Composite parent, int style, Procedure1<Tree> function) {
		val result = new Tree(parent, style)
		function.apply(result)
		return result
	}

	def TreeViewer newTreeViewer(Tree parent, Procedure1<TreeViewer> function) {
		val result = new TreeViewer(parent)
		function.apply(result)
		return result
	}

	def Button newButton(Composite parent, int style, Procedure1<Button> function) {
		val result = new Button(parent, style)
		function.apply(result)
		return result
	}

	def Text newText(Composite parent, int style, Procedure1<Text> function) {
		val result = new Text(parent, style)
		function.apply(result)
		return result
	}

	def Text newText(Composite parent, Procedure1<Text> function, int... styles) {
		val result = new Text(parent, styles.flagged)
		function.apply(result)
		return result
	}

	def GridData newGridData(boolean h, boolean v) {
		GridDataFactory::fillDefaults.grab(h, v).create
	}

	def GridData newGridData() {
		newGridData(false, false)
	}

	def GridLayout newGridLayout() {
		newGridLayout(1)
	}

	def GridLayout newGridLayout(int columns) {
		GridLayoutFactory::fillDefaults.numColumns(columns).create
	}

	def GridLayout newGridLayoutSwt() {
		newGridLayoutSwt(1)
	}

	def GridLayout newGridLayoutSwt(int columns) {
		GridLayoutFactory::swtDefaults.numColumns(columns).create
	}

	def Composite newComposite(Composite parent) {
		new Composite(parent, SWT::NONE)
	}

	def Group newGroup(Composite parent) {
		new Group(parent, SWT::NONE)
	}
}
