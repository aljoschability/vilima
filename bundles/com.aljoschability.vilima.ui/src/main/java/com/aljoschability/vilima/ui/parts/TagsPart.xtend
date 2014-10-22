package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.helpers.VilimaTagHelper
import java.util.List
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.ui.part.PageBook
import com.aljoschability.vilima.writing.TagsWriter

public class TagsPart {
	List<MkFile> files

	PageBook book

	TagsTypeNonePart partTypeNone
	TagsTypeMoviePart partTypeMovie
	TagsTypeShowPart partTypeShow

	Button typeControlNone
	Button typeControlMovie
	Button typeControlShow

	new() {
		partTypeNone = new TagsTypeNonePart()
		partTypeMovie = new TagsTypeMoviePart()
		partTypeShow = new TagsTypeShowPart()
	}

	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::swtDefaults().create

		// content type
		createContentTypeGroup(composite)

		book = new PageBook(composite, SWT::NONE)
		book.layoutData = GridDataFactory::fillDefaults().grab(true, true).create

		// none
		partTypeNone.create(book)

		// movie
		partTypeMovie.create(book)

		// show
		partTypeShow.create(book)

		createSaveButton(composite)
	}

	def private void createContentTypeGroup(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory.swtDefaults.numColumns(3).create
		group.layoutData = GridDataFactory.fillDefaults.grab(true, false).create
		group.text = "Content Type"

		typeControlNone = new Button(group, SWT::RADIO)
		typeControlNone.text = "None"
		typeControlNone.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					setContentType(null)
				}
			});

		typeControlMovie = new Button(group, SWT::RADIO)
		typeControlMovie.text = "Movie"
		typeControlMovie.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					setContentType("Movie")
				}
			});

		typeControlShow = new Button(group, SWT::RADIO)
		typeControlShow.text = "TV Show"
		typeControlShow.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					setContentType("TV Show")
				}
			});
	}

	def private void setContentType(String value) {
		if (value == null) {
			for (file : files) {
				VilimaTagHelper::removeTags(file, "CONTENT_TYPE", 70, 60, 50)
			}

			book.showPage(partTypeNone.control)
		} else if ("Movie" == value) {
			for (file : files) {
				VilimaTagHelper::removeTags(file, "CONTENT_TYPE", 70, 60)
				VilimaTagHelper::setValue(file, 50, "CONTENT_TYPE", "Movie")
			}
			book.showPage(partTypeMovie.control)
		} else if ("TV Show" == value) {
			for (file : files) {
				VilimaTagHelper::removeTags(file, "CONTENT_TYPE", 60, 50)
				VilimaTagHelper::setValue(file, 70, "CONTENT_TYPE", "TV Show")
			}
			book.showPage(partTypeShow.control)
		}

		partTypeNone.input = files
		partTypeMovie.input = files
		partTypeShow.input = files
	}

	def private void createSaveButton(Composite parent) {
		val saveButton = new Button(parent, SWT::PUSH)
		saveButton.text = "Save"
		saveButton.layoutData = GridDataFactory::fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		saveButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					val w = new TagsWriter()
					for (file : files) {
						w.write(file)
					}
				}
			})
	}

	@Inject
	def void handleSelection(@Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {

		// collect selected files
		files = newArrayList
		if (selection != null && !selection.empty) {
			for (element : selection.toArray) {
				if (element instanceof MkFile) {
					files += element
				}
			}
		}

		// fill child parts
		partTypeNone.input = files
		partTypeMovie.input = files
		partTypeShow.input = files

		// set selected content type
		if (files.size == 1) {
			showType(VilimaTagHelper::getValue(files.get(0), "CONTENT_TYPE", 70, 50))
		} else if (!files.empty) {
			val firstType = VilimaTagHelper::getValue(files.get(0), "CONTENT_TYPE", 70, 50)

			for (file : files) {
				val type = VilimaTagHelper::getValue(file, "CONTENT_TYPE", 70, 50)
				if (firstType != type) {

					// abort
					showType(null)
					return
				}
			}

			showType(firstType)
		}
	}

	def private void showType(String value) {
		if (value == "Movie" || value == "Film") {
			typeControlNone.selection = false
			typeControlMovie.selection = true
			typeControlShow.selection = false
			book.showPage(partTypeMovie.control)
		} else if (value == "TV Show" || value == "Show" || value == "Series") {
			typeControlNone.selection = false
			typeControlMovie.selection = false
			typeControlShow.selection = true
			book.showPage(partTypeShow.control)
		} else {
			typeControlNone.selection = true
			typeControlMovie.selection = false
			typeControlShow.selection = false
			book.showPage(partTypeNone.control)
		}
	}
}
