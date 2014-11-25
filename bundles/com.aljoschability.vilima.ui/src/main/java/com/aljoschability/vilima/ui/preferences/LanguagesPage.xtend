package com.aljoschability.vilima.ui.preferences

import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.ui.IWorkbenchPreferencePage
import org.eclipse.ui.IWorkbench
import com.aljoschability.vilima.ui.Activator
import org.eclipse.jface.preference.StringFieldEditor

class LanguagesPage extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {
	override protected createFieldEditors() {
		addField(new StringFieldEditor("name", "labelText", fieldEditorParent))
	}

	override init(IWorkbench workbench) {
		preferenceStore = Activator::get.preferenceStore
		description = "description"
	}
}
