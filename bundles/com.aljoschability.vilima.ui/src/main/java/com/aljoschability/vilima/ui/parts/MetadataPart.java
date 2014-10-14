package com.aljoschability.vilima.ui.parts;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.inject.Named;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.e4.core.di.annotations.Optional;
import org.eclipse.e4.ui.di.Persist;
import org.eclipse.e4.ui.model.application.ui.MDirtyable;
import org.eclipse.e4.ui.services.IServiceConstants;
import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.layout.GridLayoutFactory;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.part.PageBook;

import com.aljoschability.vilima.MkFileTagEntry;
import com.aljoschability.vilima.MkFile;
import com.aljoschability.vilima.MkFileTag;

public class MetadataPart {
	@Inject
	private MDirtyable dirtyable;

	private final Map<String, Control> controls;

	private PageBook book;

	private Composite movieComposite;
	private Composite showComposite;
	private Composite unknownComposite;

	private Text fullText;

	private MkFile input;

	@Persist
	public void doSave(IProgressMonitor monitor) {
		System.out.println("we should save now!");
	}

	public MetadataPart() {
		controls = new LinkedHashMap<>();
	}

	@PostConstruct
	public void create(Composite parent) {
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().create());

		createTypeGroup(composite);

		book = new PageBook(composite, SWT.NONE);
		book.setLayoutData(GridDataFactory.fillDefaults().grab(true, true).create());

		createUnknownControls(book);
		createMovieControls(book);
		createShowControls(book);
	}

	private void createTypeGroup(Composite parent) {
		Group typeGroup = new Group(parent, SWT.NONE);
		typeGroup.setLayout(GridLayoutFactory.swtDefaults().numColumns(3).create());
		typeGroup.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		typeGroup.setText("Type");

		Button typeDataUnknownButton = new Button(typeGroup, SWT.RADIO);
		typeDataUnknownButton.setText("Unknown");
		typeDataUnknownButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				book.showPage(unknownComposite);
			}
		});

		Button typeDataMovieButton = new Button(typeGroup, SWT.RADIO);
		typeDataMovieButton.setText("Movie");
		typeDataMovieButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				book.showPage(movieComposite);
			}
		});
		Button typeDataShowButton = new Button(typeGroup, SWT.RADIO);
		typeDataShowButton.setText("TV Show");
		typeDataShowButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				book.showPage(showComposite);
			}
		});
	}

	private void createShowControls(Composite parent) {
		showComposite = new Composite(parent, SWT.NONE);
		showComposite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		showComposite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// show
		Label showLabel = new Label(showComposite, SWT.TRAIL);
		showLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		showLabel.setText("Show");

		Text showData = new Text(showComposite, SWT.BORDER);
		showData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.show", showData);

		// genre
		Label genreLabel = new Label(showComposite, SWT.TRAIL);
		genreLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		genreLabel.setText("Genre");

		Text genreData = new Text(showComposite, SWT.BORDER);
		genreData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.genre", genreData);

		// season
		Label seasonLabel = new Label(showComposite, SWT.TRAIL);
		seasonLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		seasonLabel.setText("Season");

		Text seasonData = new Text(showComposite, SWT.BORDER);
		seasonData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.season", seasonData);

		// episode
		Label episodeLabel = new Label(showComposite, SWT.TRAIL);
		episodeLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		episodeLabel.setText("Episode");

		Text episodeData = new Text(showComposite, SWT.BORDER);
		episodeData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.episode", episodeData);

		// title
		Label titleLabel = new Label(showComposite, SWT.TRAIL);
		titleLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		titleLabel.setText("Title");

		Text titleData = new Text(showComposite, SWT.BORDER);
		titleData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.title", titleData);

		// date
		Label dateLabel = new Label(showComposite, SWT.TRAIL);
		dateLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		dateLabel.setText("Date");

		Text dateData = new Text(showComposite, SWT.BORDER);
		dateData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.date", dateData);

		// comment
		Label commentLabel = new Label(showComposite, SWT.TRAIL);
		commentLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		commentLabel.setText("Comment");

		Text commentData = new Text(showComposite, SWT.BORDER);
		commentData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("show.comment", commentData);
	}

	private void createMovieControls(Composite parent) {
		movieComposite = new Composite(parent, SWT.NONE);
		movieComposite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		movieComposite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// title
		Label titleLabel = new Label(movieComposite, SWT.TRAIL);
		titleLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		titleLabel.setText("Title");

		Text titleData = new Text(movieComposite, SWT.BORDER);
		titleData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		titleData.addModifyListener(new ModifyListener() {
			@Override
			public void modifyText(ModifyEvent e) {
				// String before = titleData.getText();
				// String after = null;
				// System.out.println(input);
				//
				// dirtyable.setDirty(true);
			}
		});
		controls.put("movie.title", titleData);

		// date
		Label dateLabel = new Label(movieComposite, SWT.TRAIL);
		dateLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		dateLabel.setText("Date");

		Text dateData = new Text(movieComposite, SWT.BORDER);
		dateData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("movie.date", dateData);

		// genre
		Label genreLabel = new Label(movieComposite, SWT.TRAIL);
		genreLabel.setLayoutData(GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).create());
		genreLabel.setText("Genre");

		Text genreData = new Text(movieComposite, SWT.BORDER);
		genreData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		controls.put("movie.genre", genreData);
	}

	private void createUnknownControls(Composite parent) {
		unknownComposite = new Composite(parent, SWT.NONE);
		unknownComposite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		unknownComposite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		fullText = new Text(unknownComposite, SWT.BORDER | SWT.MULTI | SWT.V_SCROLL | SWT.H_SCROLL);
		fullText.setLayoutData(GridDataFactory.fillDefaults().grab(true, true).create());
	}

	private String getReleaseDate(MkFile file) {
		for (MkFileTag tag : file.getTags()) {
			for (MkFileTagEntry entry : tag.getEntries()) {
				String value = findTagValue(entry, "DATE_RELEASE");
				if (value != null) {
					return value;
				}
			}
		}
		return "<not set>";
	}

	private String findTagValue(MkFileTagEntry entry, String name) {
		if (name.equals(entry.getName())) {
			return entry.getValue();
		}

		for (MkFileTagEntry child : entry.getEntries()) {
			String value = findTagValue(child, "DATE_RELEASE");
			if (value != null) {
				return value;
			}
		}

		return null;
	}

	private String getMovieTitle(MkFile file) {
		for (MkFileTag tag : file.getTags()) {
			for (MkFileTagEntry entry : tag.getEntries()) {
				String value = findTagValue(entry, "TITLE");
				if (value != null) {
					return value;
				}
			}
		}
		return "<not set>";
	}

	private void show(MkFile file) {
		if (file == null) {
			((Text) controls.get("movie.title")).setText("");
			((Text) controls.get("movie.date")).setText("");

			fullText.setText("");

			return;
		}

		((Text) controls.get("movie.title")).setText(getMovieTitle(file));
		((Text) controls.get("movie.date")).setText(getReleaseDate(file));

		fullText.setText(parseFull(file));
	}

	private String parseFull(MkFile file) {
		StringBuilder builder = new StringBuilder();
		for (MkFileTag tag : file.getTags()) {
			parseFullTag(builder, tag);
		}

		return builder.toString();
	}

	private void parseFullTag(StringBuilder builder, MkFileTag tag) {
		builder.append(tag.getTarget());
		builder.append(" (");
		builder.append(tag.getTargetText());
		builder.append("):");
		builder.append("\n");

		for (MkFileTagEntry entry : tag.getEntries()) {
			parseFullTagEntry(builder, entry, 1);
		}
	}

	private void parseFullTagEntry(StringBuilder builder, MkFileTagEntry entry, int indent) {
		for (int i = 0; i < indent; i++) {
			builder.append("\t");
		}

		builder.append(entry.getName());
		builder.append("=");
		builder.append(entry.getValue());
		builder.append("\n");

		for (MkFileTagEntry child : entry.getEntries()) {
			parseFullTagEntry(builder, child, indent + 1);
		}
	}

	@Inject
	public void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		input = null;

		if (selection != null && selection.size() == 1) {
			Object selected = selection.getFirstElement();
			if (selected instanceof MkFile) {
				input = (MkFile) selected;
			}
		}

		if (book != null && !book.isDisposed()) {
			show(input);
		}
	}
}
