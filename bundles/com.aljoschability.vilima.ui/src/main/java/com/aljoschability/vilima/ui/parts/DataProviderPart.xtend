package com.aljoschability.vilima.ui.parts

//import com.aljoschability.vilima.dapro.tmdb.TmdbProvider
import com.aljoschability.vilima.ScrapeMovie
import com.aljoschability.vilima.scraper.ScraperRegistry
import com.aljoschability.vilima.ui.Activator
import java.text.NumberFormat
import javax.annotation.PostConstruct
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.TreeViewerColumn
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Text

import static com.aljoschability.vilima.ui.parts.DataProviderPart.*
import org.eclipse.swt.widgets.Label
import org.eclipse.jface.viewers.IStructuredSelection
import com.aljoschability.vilima.scraper.MovieCandidate
import org.eclipse.jface.resource.ImageDescriptor
import java.net.URL
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Group
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.resource.JFaceColors
import org.eclipse.swt.graphics.Point

class DataProviderPart {

	static def private ScraperRegistry getScraperRegistry() {
		com.aljoschability.vilima.Activator::get.scraperRegistry
	}

	Text searchText

	TreeViewer viewer

	Label titleText

	Label taglineText

	Label poster

	@PostConstruct
	def void create(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::swtDefaults.numColumns(2).create
		composite.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		createLeft(composite)

		createRight(composite)
	}

	def private void createRight(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::fillDefaults.create
		composite.layoutData = GridDataFactory::fillDefaults.create

		// movies
		for (mse : scraperRegistry.movieScraperExtensions) {
			val button = new Button(composite, SWT::PUSH)
			button.text = '''Movie: «mse.name»'''
			button.image = Activator::get.getScraperImage(mse)
			button.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
			button.addSelectionListener(
				new SelectionAdapter() {
					override widgetSelected(SelectionEvent e) {
						if(viewer != null && !viewer.control.disposed) {
							viewer.input = mse.scraper.findMovie(searchText.text)
						}
					}
				})
		}

		// shows
		for (sse : scraperRegistry.showScraperExtensions) {
			val button = new Button(composite, SWT::PUSH)
			button.text = '''Show: «sse.name»'''
			button.image = Activator::get.getScraperImage(sse)
			button.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
			button.addSelectionListener(
				new SelectionAdapter() {
					override widgetSelected(SelectionEvent e) {
						if(viewer != null && !viewer.control.disposed) {
							viewer.input = sse.scraper.findShow(searchText.text)
						}
					}
				})
		}
	}

	def private void createLeft(Composite parent) {
		val composite = new Composite(parent, SWT::NONE)
		composite.layout = GridLayoutFactory::fillDefaults.create
		composite.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		searchText = new Text(composite, SWT::BORDER)
		searchText.layoutData = GridDataFactory::fillDefaults.grab(true, false).create

		viewer = new TreeViewer(composite, SWT::BORDER)
		viewer.tree.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		viewer.tree.headerVisible = true
		viewer.tree.linesVisible = true

		viewer.contentProvider = new DataProviderContentProvider
		viewer.addSelectionChangedListener(
			[
				handleSelection(viewer.selection as IStructuredSelection)
			])

		// title
		val titleColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		titleColumn.column.text = "Title"
		titleColumn.column.width = 300
		titleColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					ScrapeMovie: return element.title
				}
				return super.getText(element)
			}
		}

		// date
		val dateColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		dateColumn.column.text = "Release"
		dateColumn.column.width = 150
		dateColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					ScrapeMovie: return element.releaseDate
				}
				return super.getText(element)
			}
		}

		// vote
		val voteColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		voteColumn.column.text = "Votes"
		voteColumn.column.width = 150
		voteColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					ScrapeMovie: {
						if(element.voteCount == null || element.voteCount < 1) {
							return ""
						}
						return '''«format(element.votePercentage)»% by «element.voteCount»'''
					}
				}
				return super.getText(element)
			}

			def private format(Double percentage) {
				val nf = NumberFormat::getNumberInstance
				nf.maximumFractionDigits = 0
				return nf.format(percentage)
			}
		}

		createDetailPart(composite)
	}

	def private void createDetailPart(Composite parent) {
		val group = new Group(parent, SWT::NONE)
		group.layout = GridLayoutFactory::swtDefaults.numColumns(2).create
		group.layoutData = GridDataFactory::fillDefaults.grab(true, true).create
		group.text = "Movie Details"

		// poster
		val posterComposite = new Composite(group, SWT::BORDER)
		posterComposite.layout = GridLayoutFactory::fillDefaults.margins(2, 2).create
		posterComposite.layoutData = GridDataFactory::fillDefaults.create
		posterComposite.background = JFaceColors::getBannerBackground(posterComposite.display)

		poster = new Label(posterComposite, SWT::NONE)
		poster.layoutData = GridDataFactory::fillDefaults.hint(185,278) .create
//		poster.size = new Point(185, 278)

		// data
		val data = new Composite(group, SWT::NONE)
		data.layout = GridLayoutFactory::swtDefaults.create
		data.layoutData = GridDataFactory::fillDefaults.grab(true, true).create

		// title
		titleText = new Label(data, SWT::LEAD)
		titleText.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
		titleText.font = JFaceResources::getBannerFont

		// tagline
		taglineText = new Label(data, SWT::LEAD)
		titleText.layoutData = GridDataFactory::fillDefaults.grab(true, false).create
	}

	def private void handleSelection(IStructuredSelection selection) {
		if(selection.size != 1) {
			titleText.text = ""
			taglineText.text = ""

			if(poster.image != null) {
				val i = poster.image
				poster.image = null
				i.dispose
			}

			return
		}
		val movie = selection.firstElement as ScrapeMovie

		titleText.text = movie.title
		if(movie.tagline != null) {
			taglineText.text = movie.tagline
		}

		// poster
		if(poster.image != null) {
			val i = poster.image
			poster.image = null
			i.dispose
		}
		poster.image = ImageDescriptor::createFromURL(new URL(movie.posterUrl)).createImage
	}
}

class DataProviderContentProvider extends ArrayContentProvider implements ITreeContentProvider {
	override getChildren(Object element) {
		element.elements
	}

	override getParent(Object element) {
		return null
	}

	override hasChildren(Object element) {
		!children.empty
	}
}
