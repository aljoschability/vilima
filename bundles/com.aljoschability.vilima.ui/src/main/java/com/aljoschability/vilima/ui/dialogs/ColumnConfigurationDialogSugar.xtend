package com.aljoschability.vilima.ui.dialogs

import com.aljoschability.vilima.VilimaColumn
import com.aljoschability.vilima.VilimaColumnConfiguration
import com.aljoschability.vilima.ui.columns.ColumnCategoryExtension
import com.aljoschability.vilima.ui.columns.ColumnExtension
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnViewer
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Tree

class WidthColumnEditingSupport extends EditingSupport {
	new(ColumnViewer viewer) {
		super(viewer)
	}

	override protected canEdit(Object element) { element instanceof VilimaColumn }

	override protected getCellEditor(Object element) {
		val editor = new TextCellEditor(viewer.control as Tree, SWT::CENTER)
		editor.validator = [ value |
			if(value instanceof String) {
				try {
					if(Integer::parseInt(value.trim) > 0) {
						return null
					}
				} catch(Exception e) {
				}
			}
			return "Value must be a positive integer."
		]

		return editor
	}

	override protected getValue(Object element) {
		String.valueOf((element as VilimaColumn).width)
	}

	override protected setValue(Object element, Object value) {
		(element as VilimaColumn).width = Integer.parseInt(value as String)
		viewer.update(element, null)
	}
}

class ColumnExtensionsContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getChildren(Object element) {
		switch element {
			ColumnCategoryExtension: element.columns
			default: newArrayOfSize(0)
		}
	}

	override getParent(Object element) {
		switch element {
			ColumnExtension: element.category
			default: null
		}
	}

	override hasChildren(Object element) { !element.children.empty }
}

class VilimaColumnsContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getElements(Object element) {
		switch element {
			VilimaColumnConfiguration: element.columns.elements
			default: super.getElements(element)
		}
	}

	override getChildren(Object element) { #[] }

	override getParent(Object element) { null }

	override hasChildren(Object element) { false }
}
