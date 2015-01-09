package com.aljoschability.vilima.runtime

import org.osgi.framework.BundleContext
import org.osgi.service.log.LogService

abstract class AbstractLoggingBundleActivator implements LoggingBundleActivator {
	BundleContext context

	LogService logService

	override start(BundleContext context) {
		this.context = context

		// get log service
		logService = context.getService(context.getServiceReference(typeof(LogService)))

		initialize()
	}

	override stop(BundleContext context) {
		dispose()

		this.context = null
	}

	/**
	 * This method is called when the activator has been started. Should be used to store the singleton instance when
	 * necessary and to fill the image registry.
	 */
	protected def void initialize()

	/**
	 * This method is called before the bundle activator will be stopped. Should be used to delete the singleton
	 * instance reference.
	 */
	protected def void dispose()

	override getBundleContext() { context }

	override getBundle() { context?.bundle }

	override getSymbolicName() { bundle?.symbolicName }

	override debug(String message) {
		log(LogService::LOG_DEBUG, message)
	}

	override info(String message) {
		log(LogService::LOG_INFO, message)
	}

	override warn(String message) {
		log(LogService::LOG_WARNING, message)
	}

	override warn(Throwable throwable) {
		log(LogService::LOG_WARNING, null, throwable)
	}

	override warn(String message, Throwable throwable) {
		log(LogService::LOG_WARNING, message, throwable)
	}

	override error(String message) {
		log(LogService::LOG_ERROR, message)
	}

	override error(Throwable throwable) {
		log(LogService::LOG_ERROR, null, throwable)
	}

	override error(String message, Throwable throwable) {
		log(LogService::LOG_ERROR, message, throwable)
	}

	private def void log(int level, String message) {
		log(level, message, null)
	}

	private def void log(int level, String message, Throwable throwable) {
		logService.log(level, message, throwable)
		println('''logged "«message»" on osgi log service''')
	}
}
