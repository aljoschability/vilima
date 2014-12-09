package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.extensions.SwtExtension
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.viewers.DialogCellEditor
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Shell

class GenresSelectionDialog extends Dialog {
	extension SwtExtension = SwtExtension::INSTANCE
	IDialogSettings settings

	TableViewer viewer

	new(Shell parent) {
		super(parent)

		initializeSettings()
	}

	override protected createDialogArea(Composite parent) {
		val composite = super.createDialogArea(parent) as Composite

		createLeftSide(composite)

		return composite
	}

	def private void createLeftSide(Composite parent) {
		viewer = new TableViewer(parent, SWT::BORDER.bitwiseOr(SWT::MULTI))
		viewer.control.layoutData = newGridData(true, true)

	}

	def private void initializeSettings() {
		val bundleSettings = Activator::get.dialogSettings
		settings = bundleSettings.getSection(GenresSelectionDialog.canonicalName)
		if(settings == null) {
			bundleSettings.addNewSection(GenresSelectionDialog.canonicalName)
		}
	}

	override protected getDialogBoundsSettings() { settings }

	override protected isResizable() { true }
}

class LanguageAwareStringColumn {
	Integer level
	String name
}

class LanguageAwareStringListColumn {
}

class TestColumn extends AbstractStringColumn {
	EditingSupport editingSupport

	override getEditingSupport(TreeViewer treeViewer) {
		if(editable && editingSupport == null) {
			editingSupport = new EditingSupport(treeViewer) {
				override protected canEdit(Object element) {
					element instanceof MkFile
				}

				override protected getCellEditor(Object element) {
					val editor = new DialogCellEditor(treeViewer.tree) {
						override protected openDialogBox(Control parent) {
							val dialog = new GenresSelectionDialog(parent.shell)

							return dialog.open
						}
					}

					return editor
				}

				override protected getValue(Object element) {
					(element as MkFile).string ?: ""
				}

				override protected setValue(Object element, Object value) {
					if(value instanceof String) {
						if(set(element as MkFile, value as String)) {
							viewer.update(element, null)
						}
					}
				}
			}
		}
		return editingSupport
	}

	override protected isEditable() { true }

	override protected getString(MkFile file) {
		val text = new StringBuilder
		for (node : file.getAllTagNodes(50, "GENRE")) {
			text.append(node.value)
			text.append(", ")
		}
		return text.toString
	}
}
