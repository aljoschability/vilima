package com.aljoschability.vilima.ui;

import com.aljoschability.vilima.runtime.AbstractLoggingBundleActivator
import com.aljoschability.vilima.scraper.ScraperExtension
import com.aljoschability.vilima.services.ScraperService
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import com.aljoschability.vilima.ui.services.ColumnService
import com.aljoschability.vilima.ui.services.DialogService
import com.aljoschability.vilima.ui.services.ImageService
import com.aljoschability.vilima.ui.services.impl.ColumnServiceImpl
import com.aljoschability.vilima.ui.services.impl.DialogServiceImpl
import com.aljoschability.vilima.ui.services.impl.ImageServiceImpl
import org.eclipse.jface.dialogs.DialogSettings
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.swt.graphics.Image

final class Activator extends AbstractLoggingBundleActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {
		Activator::INSTANCE = this

		// register and start image service
		val imageService = new ImageServiceImpl(bundleContext)
		bundleContext.registerService(typeof(ImageService), imageService, null)
		imageService.start()

		// register and start column service
		val columnService = new ColumnServiceImpl(bundleContext)
		bundleContext.registerService(typeof(ColumnService), columnService, null)
		columnService.start()

		// register and start dialog service
		val dialogService = new DialogServiceImpl(bundleContext)
		bundleContext.registerService(typeof(DialogService), dialogService, null)
		dialogService.start()

		// TODO: stuff
		val reference = bundleContext.getServiceReference(typeof(ScraperService))
		val registry = bundleContext.getService(reference)

		// add movie scraper icons
		// TODO: use new image service
		for (mse : registry.movieScraperExtensions) {
			val pluginId = mse.pluginId
			val imagePath = mse.imagePath

		//val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)
		//imageRegistry.put(pluginId + "/" + imagePath, desc)
		}

		// add show scraper icons
		// TODO: use new image service
		for (sse : registry.showScraperExtensions) {
			val pluginId = sse.pluginId
			val imagePath = sse.imagePath

		//val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)
		//imageRegistry.put(pluginId + "/" + imagePath, desc)
		}
	}

	override protected dispose() {

		// stop dialog service
		val dialogServiceRef = bundleContext.getServiceReference(typeof(DialogService))
		bundleContext.getService(dialogServiceRef).stop()

		// stop column service
		val columnServiceRef = bundleContext.getServiceReference(typeof(ColumnService))
		bundleContext.getService(columnServiceRef).stop()

		// stop image service
		val imageServiceRef = bundleContext.getServiceReference(typeof(ImageService))
		bundleContext.getService(imageServiceRef).stop()

		Activator::INSTANCE = null
	}

	@Deprecated
	def IDialogSettings getDialogSettings() {

		// TODO: use new dialog service
		new DialogSettings("x")
	}

	@Deprecated
	def IPreferenceStore getPreferenceStore() {

		// TODO: use new dialog service
		//new ScopedPreferenceStore(InstanceScope::INSTANCE, symbolicName)
	}

	def Image getScraperImage(ScraperExtension ext) {
		// TODO: use new image service
		//getImage(ext.pluginId + "/" + ext.imagePath)
	}

	def void registerColumnExtensionImages(MkFileColumnRegistry registry) {

		// TODO: use new image service
		for (category : registry.columnCategories) {
			if(category.imagePath != null) {
				//val desc = AbstractUIPlugin::imageDescriptorFromPlugin(category.namespace, category.imagePath)
				//imageRegistry.put(category.namespace + "/" + category.imagePath, desc)
			}
		}
	}

	def ImageService getImageService() {
		val ref = bundleContext.getServiceReference(typeof(ImageService))
		bundleContext.getService(ref)
	}
}
