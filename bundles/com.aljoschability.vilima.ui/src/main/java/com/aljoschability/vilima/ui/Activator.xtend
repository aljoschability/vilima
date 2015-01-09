package com.aljoschability.vilima.ui;

import com.aljoschability.vilima.runtime.AbstractLoggingBundleActivator
import com.aljoschability.vilima.scraper.ScraperExtension
import com.aljoschability.vilima.ui.columns.MkFileColumnRegistry
import com.aljoschability.vilima.ui.services.ColumnService
import com.aljoschability.vilima.ui.services.DialogService
import com.aljoschability.vilima.ui.services.ImageService
import com.aljoschability.vilima.ui.services.impl.ColumnServiceImpl
import com.aljoschability.vilima.ui.services.impl.DialogServiceImpl
import com.aljoschability.vilima.ui.services.impl.ImageServiceImpl
import org.eclipse.core.runtime.preferences.InstanceScope
import org.eclipse.jface.dialogs.DialogSettings
import org.eclipse.jface.dialogs.IDialogSettings
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.ui.preferences.ScopedPreferenceStore

final class Activator extends AbstractLoggingBundleActivator {
	static Activator INSTANCE

	def static get() {
		Activator::INSTANCE
	}

	override protected initialize() {

		// register image service
		bundleContext.registerService(typeof(ImageService), new ImageServiceImpl(bundleContext), null)
		info("The image service has been registered.")

		// register column service
		bundleContext.registerService(typeof(ColumnService), new ColumnServiceImpl(bundleContext), null)
		info("The column service has been registered.")

		// register dialog settings service
		bundleContext.registerService(typeof(DialogService), new DialogServiceImpl(bundleContext), null)
		info("The dialog service has been registered.")

		Activator::INSTANCE = this

		// TODO: stuff
		val reg = com.aljoschability.vilima.Activator::get.scraperRegistry

		// add movie scraper icons
		// TODO: use new image service
		for (mse : reg.movieScraperExtensions) {
			val pluginId = mse.pluginId
			val imagePath = mse.imagePath
			val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)

		//imageRegistry.put(pluginId + "/" + imagePath, desc)
		}

		// add show scraper icons
		// TODO: use new image service
		for (sse : reg.showScraperExtensions) {
			val pluginId = sse.pluginId
			val imagePath = sse.imagePath
			val desc = AbstractUIPlugin::imageDescriptorFromPlugin(pluginId, imagePath)

		//imageRegistry.put(pluginId + "/" + imagePath, desc)
		}
	}

	override protected dispose() {
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
		new ScopedPreferenceStore(InstanceScope::INSTANCE, symbolicName)
	}

	def Image getScraperImage(ScraperExtension ext) {
		// TODO: use new image service
		//getImage(ext.pluginId + "/" + ext.imagePath)
	}

	def void registerColumnExtensionImages(MkFileColumnRegistry registry) {

		// TODO: use new image service
		for (category : registry.columnCategories) {
			if(category.imagePath != null) {
				val desc = AbstractUIPlugin::imageDescriptorFromPlugin(category.namespace, category.imagePath)

			//imageRegistry.put(category.namespace + "/" + category.imagePath, desc)
			}
		}
	}

	def ImageService getImageService() {
		val ref = bundleContext.getServiceReference(typeof(ImageService))
		bundleContext.getService(ref)
	}
}
