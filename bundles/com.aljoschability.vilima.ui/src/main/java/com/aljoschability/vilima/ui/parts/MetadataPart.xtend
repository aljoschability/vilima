package com.aljoschability.vilima.ui.parts;

import com.aljoschability.vilima.MkFile
import java.util.List
import java.util.Map
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
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.part.PageBook

public class MetadataPart {
	val Map<String, Control> controls

	PageBook book

	DataMoviePart moviePart

	Composite showComposite;

	List<MkFile> input

	DataAllPart allPart

	new() {
		controls = newLinkedHashMap()
	}

	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().create());

		createTypeGroup(composite);

		book = new PageBook(composite, SWT.NONE);
		book.setLayoutData(GridDataFactory.fillDefaults().grab(true, true).create());

		createUnknownControls(book)
		createMovieControls(book)
		createShowControls(book)

		book.showPage(allPart.control)

		createSaveButton(composite)
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

	def private void createTypeGroup(Composite parent) {
		val typeGroup = new Group(parent, SWT.NONE);
		typeGroup.setLayout(GridLayoutFactory.swtDefaults().numColumns(3).create());
		typeGroup.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		typeGroup.setText("Type");

		val typeDataUnknownButton = new Button(typeGroup, SWT.RADIO);
		typeDataUnknownButton.setText("Unknown");
		typeDataUnknownButton.selection = true
		typeDataUnknownButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					book.showPage(allPart.control)
				}
			});

		val typeDataMovieButton = new Button(typeGroup, SWT.RADIO);
		typeDataMovieButton.setText("Movie");
		typeDataMovieButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					book.showPage(moviePart.control)
				}
			});

		val typeDataShowButton = new Button(typeGroup, SWT.RADIO);
		typeDataShowButton.setText("TV Show");
		typeDataShowButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					book.showPage(showComposite);
				}
			});
	}

	def private void createUnknownControls(Composite parent) {
		val composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		composite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		allPart = new DataAllPart()
		allPart.create(composite)
	}

	def private void createMovieControls(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory.swtDefaults.create
		composite.layoutData = GridDataFactory.fillDefaults().grab(true, false).create

		moviePart = new DataMoviePart()
		moviePart.create(composite)
	}

	def private void createShowControls(Composite parent) {
		showComposite = new Composite(parent, SWT.NONE);
		showComposite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		showComposite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// show
		val showLabel = new Label(showComposite, SWT.TRAIL);
		showLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		showLabel.setText("Show");

		val showData = new Text(showComposite, SWT.BORDER);
		showData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.show", showData);

		// genre
		val genreLabel = new Label(showComposite, SWT.TRAIL);
		genreLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		genreLabel.setText("Genre");

		val genreData = new Text(showComposite, SWT.BORDER);
		genreData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.genre", genreData);

		// season
		val seasonLabel = new Label(showComposite, SWT.TRAIL);
		seasonLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		seasonLabel.setText("Season");

		val seasonData = new Text(showComposite, SWT.BORDER);
		seasonData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.season", seasonData);

		// episode
		val episodeLabel = new Label(showComposite, SWT.TRAIL);
		episodeLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		episodeLabel.setText("Episode");

		val episodeData = new Text(showComposite, SWT.BORDER);
		episodeData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.episode", episodeData);

		// title
		val titleLabel = new Label(showComposite, SWT.TRAIL);
		titleLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		titleLabel.setText("Title");

		val titleData = new Text(showComposite, SWT.BORDER);
		titleData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.title", titleData);

		// date
		val dateLabel = new Label(showComposite, SWT.TRAIL);
		dateLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		dateLabel.setText("Date");

		val dateData = new Text(showComposite, SWT.BORDER);
		dateData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.date", dateData);

		// comment
		val commentLabel = new Label(showComposite, SWT.TRAIL);
		commentLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		commentLabel.setText("Comment");

		val commentData = new Text(showComposite, SWT.BORDER);
		commentData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.comment", commentData);
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

			moviePart.input = input
			allPart.input = input
		}
	}
}
