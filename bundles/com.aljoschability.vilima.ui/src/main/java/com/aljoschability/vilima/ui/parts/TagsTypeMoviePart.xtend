package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkFileTagEntry
import java.util.List
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

class TagsTypeMoviePart {
	Combo titleControl
	Combo subtitleControl
	Combo dateControl
	Combo genresControl

	Composite composite

	Combo imdbControl

	Combo traktControl

	Combo tmdbControl

	def void create(Composite parent) {
		composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::fillDefaults.numColumns(2).create
		composite.layoutData = GridDataFactory.fillDefaults.grab(true, false).create

		// title
		val titleLabel = new Label(composite, SWT::TRAIL)
		titleLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		titleLabel.text = "Title"

		titleControl = new Combo(composite, SWT::DROP_DOWN)
		titleControl.layoutData = GridDataFactory.fillDefaults.grab(true, false).create
		titleControl.addModifyListener([e|setValue(50, "TITLE", titleControl.text)])

		// subtitle
		val subtitleLabel = new Label(composite, SWT::TRAIL)
		subtitleLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		subtitleLabel.text = "Subtitle"

		subtitleControl = new Combo(composite, SWT::DROP_DOWN)
		subtitleControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		subtitleControl.addModifyListener([e|setValue(50, "SUBTITLE", subtitleControl.text)])

		// date
		val dateLabel = new Label(composite, SWT::NONE)
		dateLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		dateLabel.text = "Date"

		dateControl = new Combo(composite, SWT::DROP_DOWN);
		dateControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		dateControl.addModifyListener([e|setValue(50, "DATE_RELEASE", dateControl.text)])

		// genres
		val genresLabel = new Label(composite, SWT::TRAIL)
		genresLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		genresLabel.text = "Genres"

		genresControl = new Combo(composite, SWT::DROP_DOWN);
		genresControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		genresControl.addModifyListener([e|setValues(50, "GENRE", genresControl.text, ",")])

		// identifiers group
		createIdentifiersGroup(composite)
	}

	def private void createIdentifiersGroup(Composite parent) {
		val group = new Group(composite, SWT::NONE)
		group.layout = GridLayoutFactory::swtDefaults.numColumns(2).create
		group.layoutData = GridDataFactory::fillDefaults.span(2, 1).create
		group.text = "Identifiers"

		// IMDB
		val imdbLabel = new Label(group, SWT::TRAIL)
		imdbLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		imdbLabel.text = "IMDB"

		imdbControl = new Combo(group, SWT::DROP_DOWN);
		imdbControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		imdbControl.addModifyListener([e|setValues(50, "IMDB", imdbControl.text, ",")])

		// TMDB
		val tmdbLabel = new Label(group, SWT::TRAIL)
		tmdbLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		tmdbLabel.text = "TMDB"

		tmdbControl = new Combo(group, SWT::DROP_DOWN);
		tmdbControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		tmdbControl.addModifyListener([e|setValues(50, "TMDB", tmdbControl.text, ",")])

		// TRAKT
		val traktLabel = new Label(group, SWT::TRAIL)
		traktLabel.layoutData = GridDataFactory.fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		traktLabel.text = "Trakt"

		traktControl = new Combo(group, SWT::DROP_DOWN);
		traktControl.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		traktControl.addModifyListener([e|setValues(50, "TRAKT", traktControl.text, ",")])
	}

	def private void setValue(int level, String name, String value) {
		if (value != null && !value.empty) {
			println('''Set "«level»:«name»" to "«value»".''')
		}
	}

	def private void setValues(int level, String name, String value, String separator) {
		if (value != null && !value.empty) {
			println('''Set "«level»:«name»" to "«value»" (splitted by «separator»).''')
		}
	}

	def setInput(List<MkFile> files) {
		setTitleInput(files)
		setSubtitleInput(files)
		setDateInput(files)
		setGenresInput(files)
	}

	def private void setTitleInput(List<MkFile> files) {
		val List<String> items = newArrayList

		for (file : files) {
			items += findTagStrings(file, 50, "TITLE")
		}

		titleControl.items = items

		if (items.empty) {
			titleControl.text = ""
		} else if (items.size == 1) {
			titleControl.text = items.get(0)
		} else {
			titleControl.text = "<multiple>"
		}
	}

	def private void setSubtitleInput(List<MkFile> files) {
		val List<String> items = newArrayList

		for (file : files) {
			items += findTagStrings(file, 50, "SUBTITLE")
		}

		subtitleControl.items = items

		if (items.empty) {
			subtitleControl.text = ""
		} else if (items.size == 1) {
			subtitleControl.text = items.get(0)
		} else {
			subtitleControl.text = "<multiple>"
		}
	}

	def private void setDateInput(List<MkFile> files) {
		val List<String> items = newArrayList

		for (file : files) {
			items += findTagStrings(file, 50, "DATE_RELEASED")
		}

		dateControl.items = items

		if (items.empty) {
			dateControl.text = ""
		} else if (items.size == 1) {
			dateControl.text = items.get(0)
		} else {
			dateControl.text = "<multiple>"
		}
	}

	def private void setGenresInput(List<MkFile> files) {
		val List<String> items = newArrayList

		for (file : files) {
			val strings = findTagStrings(file, 50, "GENRE")
			if (!strings.empty) {
				val builder = new StringBuilder
				for (genre : strings) {
					builder.append(genre)
					builder.append(", ")
				}
				items += builder.substring(0, builder.length - 2)
			}
		}

		genresControl.items = items

		if (items.empty) {
			genresControl.text = ""
		} else if (items.size == 1) {
			genresControl.text = items.get(0)
		} else {
			genresControl.text = "<multiple>"
		}
	}

	def private String findTagValue(MkFileTagEntry entry, String name) {
		if (name.equals(entry.getName())) {
			return entry.getValue();
		}

		for (MkFileTagEntry child : entry.getEntries()) {
			val value = findTagValue(child, name);
			if (value != null) {
				return value;
			}
		}

		return null;
	}

	def private static List<String> findTagStrings(MkFile file, int level, String name) {
		val list = newArrayList
		for (tag : file.tags) {
			if (tag.target == level) {
				for (entry : tag.entries) {
					if (entry.name == name) {
						if (entry.value != null) {
							list += entry.value
						}
					}
				}
			}
		}
		return list
	}

	def Composite getControl() {
		return composite
	}
}
