package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.helpers.VilimaTagHelper
import java.util.List
import java.util.Map
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

class TagsTypeMoviePart {
	Composite composite

	Combo titleControl
	Combo dateControl
	Combo genresControl

	Combo imdbControl
	Combo traktControl
	Combo tmdbControl

	def void create(Composite parent) {
		composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::fillDefaults.create
		composite.layoutData = GridDataFactory::fillDefaults.grab(true, false).create

		// information group
		createInformationGroup(composite)

		// identifiers group
		createIdentificationGroup(composite)
	}

	def private void createInformationGroup(Composite parent) {
		val group = createGroup(parent, "Information")

		// title
		createLabel(group, "Title")

		titleControl = createCombo(group)
		titleControl.addModifyListener([e|setValue(50, "TITLE", titleControl.text)])

		// date
		createLabel(group, "Release")

		dateControl = createCombo(group)
		dateControl.addModifyListener([e|setValue(50, "DATE_RELEASE", dateControl.text)])

		// genres
		createLabel(group, "Genres")

		genresControl = createCombo(group)
		genresControl.addModifyListener([e|setValues(50, "GENRE", genresControl.text, ",")])
	}

	def private void createIdentificationGroup(Composite parent) {
		val group = createGroup(parent, "Identification")

		// IMDB
		createLabel(group, "IMDB")

		imdbControl = createCombo(group)
		imdbControl.addModifyListener([e|setValues(50, "IMDB", imdbControl.text, ",")])

		// TMDB
		createLabel(group, "TMDB")

		tmdbControl = createCombo(group)
		tmdbControl.addModifyListener([e|setValues(50, "TMDB", tmdbControl.text, ",")])

		// TRAKT
		createLabel(group, "Trakt")

		traktControl = createCombo(group)
		traktControl.addModifyListener([e|setValues(50, "TRAKT", traktControl.text, ",")])
	}

	def private void setValue(int level, String name, String value) {
		if (value != null && !value.empty && value != "<multiple>") {
			println('''Set "«level»:«name»" to "«value»".''')
		}
	}

	def private void setValues(int level, String name, String value, String separator) {
		if (value != null && !value.empty && value != "<multiple>") {
			println('''Set "«level»:«name»" to "«value»" (splitted by «separator»).''')
		}
	}

	def void setInput(List<MkFile> files) {
		if (titleControl == null || titleControl.disposed) {
			return
		}

		fillCombo(files, titleControl, 50, "TITLE")
		fillCombo(files, dateControl, 50, "DATE_RELEASED")

		//fillCombo(files, genresControl, 50, "GENRE")
		fillCombo(files, imdbControl, 50, "IMDB")
		fillCombo(files, tmdbControl, 50, "TMDB")
		fillCombo(files, traktControl, 50, "TRAKT")
	}

	def private void fillCombo(List<MkFile> files, Combo control, int target, String name) {
		val Map<MkFile, String> values = newLinkedHashMap

		if (files != null) {
			for (file : files) {
				val tagValues = VilimaTagHelper::getValues(file, name, target)
				if (tagValues.empty) {
					values.put(file, "")
				} else if (tagValues.size == 1) {
					values.put(file, tagValues.get(0))
				} else {
					println("found more than one or no value for tag:" + name)
				}
			}
		}

		control.items = values.values

		if (values.empty) {
			control.text = ""
		} else if (values.size == 1) {
			control.text = values.values.get(0)
		} else {
			control.text = "<multiple>"
		}

	}

	def Composite getControl() {
		return composite
	}

	def private static Group createGroup(Composite parent, String text) {
		val group = new Group(parent, SWT::NONE)
		group.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		group.layout = GridLayoutFactory::swtDefaults.numColumns(2).create
		group.text = text

		return group
	}

	def private static void createLabel(Composite parent, String text) {
		val label = new Label(parent, SWT::TRAIL)
		label.layoutData = GridDataFactory::fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		label.text = text
	}

	def private static Combo createCombo(Composite parent) {
		val combo = new Combo(parent, SWT::DROP_DOWN)
		combo.layoutData = GridDataFactory::fillDefaults.grab(true, false).create

		return combo
	}
}
