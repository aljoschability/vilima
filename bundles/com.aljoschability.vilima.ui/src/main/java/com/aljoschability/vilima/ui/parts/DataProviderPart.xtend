package com.aljoschability.vilima.ui.parts

//import com.aljoschability.vilima.dapro.tmdb.TmdbProvider
import com.aljoschability.vilima.scraper.MovieCandidate
import com.aljoschability.vilima.scraper.ScraperRegistry
import com.aljoschability.vilima.scraper.ShowCandidate
import com.aljoschability.vilima.ui.Activator
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

class DataProviderPart {

	static def private ScraperRegistry getScraperRegistry() {
		com.aljoschability.vilima.Activator::get.scraperRegistry
	}

	Text searchText

	TreeViewer viewer

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
						mse.scraper.findMovie(searchText.text)
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
						sse.scraper.findShow(searchText.text)
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

		// title
		val titleColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		titleColumn.column.text = "Title"
		titleColumn.column.width = 300
		titleColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					MovieCandidate: return element.title
					ShowCandidate: return element.title
				}
				return super.getText(element)
			}
		}

		// title
		val dateColumn = new TreeViewerColumn(viewer, SWT::LEAD)
		dateColumn.column.text = "Release"
		dateColumn.column.width = 150
		dateColumn.labelProvider = new ColumnLabelProvider {
			override getText(Object element) {
				switch element {
					MovieCandidate: return element.releaseDate
					ShowCandidate: return element.releaseDate
				}
				return super.getText(element)
			}
		}
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
