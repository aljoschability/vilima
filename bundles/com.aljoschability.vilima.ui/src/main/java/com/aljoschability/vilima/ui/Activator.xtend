package com.aljoschability.vilima.ui;

import com.aljoschability.core.ui.runtime.AbstractActivator
import com.aljoschability.vilima.scraper.ScraperExtension
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.plugin.AbstractUIPlugin

final class Activator extends AbstractActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {
		Activator::INSTANCE = this

		addImage(VilimaImages::TRIANGLE_DOWN)
		addImage(VilimaImages::TRIANGLE_LEFT)
		addImage(VilimaImages::TRIANGLE_RIGHT)
		addImage(VilimaImages::TRIANGLE_UP)

		addImage(VilimaImages::TRACK_TYPE_VIDEO)
		addImage(VilimaImages::TRACK_TYPE_AUDIO)
		addImage(VilimaImages::TRACK_TYPE_SUBTITLE)

		val reg = com.aljoschability.vilima.Activator::get.scraperRegistry

		// add movie scraper icons
		for (mse : reg.movieScraperExtensions) {
			val pluginId = mse.pluginId
			val imagePath = mse.imagePath
			val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)

			imageRegistry.put(pluginId + "/" + imagePath, desc)
		}

		// add show scraper icons
		for (sse : reg.showScraperExtensions) {
			val pluginId = sse.pluginId
			val imagePath = sse.imagePath
			val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)

			imageRegistry.put(pluginId + "/" + imagePath, desc)
		}
	}

	override protected dispose() {
		Activator::INSTANCE = null
	}

	def Image getScraperImage(ScraperExtension ext) {
		getImage(ext.pluginId + "/" + ext.imagePath)
	}

	def void registerColumnExtensionImages(MkFileColumnRegistry registry) {
		for (category : registry.columnCategories) {
			if(category.imagePath != null) {
				val desc = AbstractUIPlugin::imageDescriptorFromPlugin(category.namespace, category.imagePath)
				imageRegistry.put(category.namespace + "/" + category.imagePath, desc)
			}
		}
	}
}
