package com.aljoschability.vilima.ui;

import com.aljoschability.core.ui.runtime.AbstractActivator
import com.aljoschability.vilima.scraper.ScraperExtension
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import com.aljoschability.vilima.ui.services.ColumnService
import com.aljoschability.vilima.ui.services.ImageService
import com.aljoschability.vilima.ui.services.impl.ColumnServiceImpl
import com.aljoschability.vilima.ui.services.impl.ImageServiceImpl
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.plugin.AbstractUIPlugin

final class Activator extends AbstractActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {

		// register image service
		bundleContext.registerService(typeof(ImageService), new ImageServiceImpl(bundleContext), null)

		// register column service
		bundleContext.registerService(typeof(ColumnService), new ColumnServiceImpl(bundleContext), null)

		Activator::INSTANCE = this

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
