package com.aljoschability.vilima.ui.xtend

import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.Viewer
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Table
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.Tree
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import org.eclipse.swt.events.FocusListener
import org.eclipse.swt.events.FocusEvent
import org.eclipse.swt.events.FocusAdapter

class SwtExtension {
	val public static INSTANCE = new SwtExtension

	def boolean isActive(Control control) { control != null && !control.disposed }

	def boolean isActive(Viewer viewer) { viewer != null && viewer.control.active }

	def SashForm newSashForm(Composite parent, int style, Procedure1<SashForm> function) {
		val result = new SashForm(parent, style)
		function.apply(result)
		return result
	}

	def Label newLabel(Composite parent, Procedure1<Label> function, int... styles) {
		val result = new Label(parent, styles.flagged)
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

	@Deprecated
	def Button newButton(Composite parent, int style, Procedure1<Button> function) {
		val result = new Button(parent, style)
		function.apply(result)
		return result
	}

	def Button newButton(Composite parent, Procedure1<Button> function, int... styles) {
		val result = new Button(parent, styles.flagged)
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

	def GridData newGridDataCentered() {
		GridDataFactory::fillDefaults.align(SWT::FILL, SWT::CENTER).create
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

	def ModifyListener newModifyListener(Procedure1<ModifyEvent> procedure) {
		new ModifyListener() {
			override modifyText(ModifyEvent e) {
				procedure.apply(e)
			}
		}
	}

	def SelectionListener newSelectionListener(Procedure1<SelectionEvent> procedure) {
		new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				procedure.apply(e)
			}
		}
	}

	def FocusListener newFocusLostListener(Procedure1<FocusEvent> procedure) {
		new FocusAdapter {
			override focusLost(FocusEvent e) {
				procedure.apply(e)
			}
		}
	}
}
