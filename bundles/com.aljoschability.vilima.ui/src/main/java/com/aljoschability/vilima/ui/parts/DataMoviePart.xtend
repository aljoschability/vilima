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
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.Table
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.swt.widgets.Button
import com.aljoschability.core.ui.CoreImages

class DataMoviePart {
	Combo titleControl
	Combo subtitleControl

	Combo dateControl

	TableViewer genresControl

	Composite composite

	def void create(Composite movieComposite) {
		this.composite = movieComposite

		// title
		val titleGroup = new Group(movieComposite, SWT::NONE)
		titleGroup.layoutData = GridDataFactory.fillDefaults.grab(true, false).create
		titleGroup.layout = GridLayoutFactory::swtDefaults.create
		titleGroup.text = "Title"

		titleControl = new Combo(titleGroup, SWT::DROP_DOWN)
		titleControl.layoutData = GridDataFactory.fillDefaults().grab(true, false).create
		titleControl.addModifyListener([e|modify(50, "TITLE", titleControl.text)])

		// subtitle
		val subtitleGroup = new Group(movieComposite, SWT::NONE)
		subtitleGroup.layoutData = GridDataFactory.fillDefaults.grab(true, false).create
		subtitleGroup.layout = GridLayoutFactory::swtDefaults.create
		subtitleGroup.text = "Subtitle"

		subtitleControl = new Combo(subtitleGroup, SWT::DROP_DOWN)
		subtitleControl.layoutData = GridDataFactory::fillDefaults().grab(true, false).create
		subtitleControl.addModifyListener([e|modify(50, "SUBTITLE", subtitleControl.text)])

		// date
		val dateGroup = new Group(movieComposite, SWT::NONE);
		dateGroup.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		dateGroup.layout = GridLayoutFactory::swtDefaults.create
		dateGroup.text = "Date"

		dateControl = new Combo(dateGroup, SWT::DROP_DOWN);
		dateControl.layoutData = GridDataFactory::fillDefaults().grab(true, false).create
		dateControl.addModifyListener([e|modify(50, "DATE_RELEASE", dateControl.text)])

		// genres
		val genresGroup = new Group(movieComposite, SWT::NONE)
		genresGroup.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		genresGroup.layout = GridLayoutFactory::swtDefaults.numColumns(2).create
		genresGroup.text = "Genres"

		// genres: table
		val genresTable = new Table(genresGroup, SWT::BORDER.bitwiseOr(SWT::FULL_SELECTION))
		genresTable.layoutData = GridDataFactory.fillDefaults().grab(true, false).create
		genresTable.linesVisible = true

		genresControl = new TableViewer(genresTable)
		genresControl.contentProvider = ArrayContentProvider::getInstance
		genresControl.labelProvider = new LabelProvider

		// genres: controls
		val genresControlsComposite = new Composite(genresGroup, SWT::NONE)
		genresControlsComposite.layoutData = GridDataFactory::fillDefaults.grab(false, true).create
		genresControlsComposite.layout = GridLayoutFactory::fillDefaults.create

		val genresButtonAdd = new Button(genresControlsComposite, SWT::PUSH)
		genresButtonAdd.image = CoreImages::get(CoreImages::ADD)
		genresButtonAdd.toolTipText = "Add Genre"

		val genresButtonUp = new Button(genresControlsComposite, SWT::PUSH)
		genresButtonUp.image = CoreImages::get(CoreImages::UP)
		genresButtonUp.toolTipText = "Move Genre Up"

		val genresButtonDown = new Button(genresControlsComposite, SWT::PUSH)
		genresButtonDown.image = CoreImages::get(CoreImages::DOWN)
		genresButtonDown.toolTipText = "Move Genre Down"

		val genresButtonRemove = new Button(genresControlsComposite, SWT::PUSH)
		genresButtonRemove.image = CoreImages::get(CoreImages::REMOVE)
		genresButtonRemove.toolTipText = "Remove Selected Genre"
	}

	def private void modify(int level, String name, String value) {
		println('''Set "«level»:«name»" to "«value»".''')
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
			items += findTagStrings(file, 50, "GENRE")
		}

		if (files.size == 1) {
			genresControl.input = items
		} else {
			genresControl.input = null
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
