package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import java.util.List
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
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

public class TagsPart {
	List<MkFile> input

	PageBook book

	TagsTypeNonePart partTypeNone
	TagsTypeMoviePart partTypeMovie
	TagsTypeShowPart partTypeShow

	Button typeControlNone
	Button typeControlMovie
	Button typeControlShow

	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::swtDefaults().create

		// content type
		createContentTypeGroup(composite)

		book = new PageBook(composite, SWT::NONE)
		book.layoutData = GridDataFactory::fillDefaults().grab(true, true).create

		// none
		partTypeNone = new TagsTypeNonePart()
		partTypeNone.create(book)

		// movie
		partTypeMovie = new TagsTypeMoviePart()
		partTypeMovie.create(book)

		// show
		partTypeShow = new TagsTypeShowPart()
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

		typeControlShow = new Button(group, SWT.RADIO);
		typeControlShow.setText("TV Show");
		typeControlShow.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					setContentType("TV Show")
				}
			});
	}

	def private void setContentType(String value) {
		if (value == null) {
			partTypeNone.input = input
			book.showPage(partTypeNone.control)
		} else if ("Movie" == value) {
			book.showPage(partTypeMovie.control)
		} else if ("TV Show" == value) {
			book.showPage(partTypeShow.control)
		}
	}

	def private void createSaveButton(Composite parent) {
		val saveButton = new Button(parent, SWT::PUSH)
		saveButton.text = "Save"
		saveButton.layoutData = GridDataFactory::fillDefaults.align(SWT::TRAIL, SWT::CENTER).create
		saveButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					println("mkvpropedit.exe --help")
				}
			})
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		if (selection != null) {
			input = newArrayList
			for (element : selection.toArray) {
				if (element instanceof MkFile) {
					input += element
				}
			}

			partTypeNone.input = input
			partTypeMovie.input = input
			partTypeShow.input = input
		}
	}
}
