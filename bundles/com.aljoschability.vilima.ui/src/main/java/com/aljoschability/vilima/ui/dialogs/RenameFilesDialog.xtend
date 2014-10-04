package com.aljoschability.vilima.ui.dialogs

import org.eclipse.jface.dialogs.TitleAreaDialog
import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.SWT
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.swt.widgets.Tree
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.widgets.TreeColumn

class RenameFilesDialog extends TitleAreaDialog {

	TreeViewer previewViewer

	new(Shell shell) {
		super(shell)

		blockOnOpen = false
	}

	override protected createDialogArea(Composite parent) {
		val composite = super.createDialogArea(parent) as Composite
		composite.layout = GridLayoutFactory::swtDefaults.create

		createConfigurationControls(composite)

		createPreviewGroup(composite)

		title = "Rename Files"
		message = "Rename the selected files."

		return composite
	}

	def private createConfigurationControls(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::swtDefaults.create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.text = "Configuration"
	}

	def private createPreviewGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::swtDefaults.create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		group.text = "Preview"

		val tree = new Tree(group, SWT::BORDER)
		tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		tree.linesVisible = true
		tree.headerVisible = true

		previewViewer = new TreeViewer(tree)

		// original
		val orgColumn = new TreeColumn(tree, SWT::LEAD)
		orgColumn.moveable = false
		orgColumn.resizable = true
		orgColumn.width = 100
		orgColumn.text = "Original Name"
		
		// original
		val targetColumn = new TreeColumn(tree, SWT::LEAD)
		targetColumn.moveable = false
		targetColumn.resizable = true
		targetColumn.width = 100
		targetColumn.text = "Target Name"
	}

	override protected isResizable() { true }
}
