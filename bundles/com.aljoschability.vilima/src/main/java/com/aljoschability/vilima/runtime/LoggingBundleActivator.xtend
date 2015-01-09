package com.aljoschability.vilima.runtime

import org.osgi.framework.Bundle
import org.osgi.framework.BundleActivator
import org.osgi.framework.BundleContext

/**
 * Eases getting the plug-in identifier, name and other {@link BundleActivator bundle} specific
 * things as well as an easy access to the logging framework.
 * 
 * @author Aljoscha Hark <aljoschability@gmail.com>
 */
interface LoggingBundleActivator extends BundleActivator {

	/**
	 * Delivers the bundle context.
	 * 
	 * @return Returns the bundle context.
	 */
	def BundleContext getBundleContext()

	/**
	 * Delivers the bundle. Will be only available when the bundle has been
	 * {@link #start(BundleContext) started}.
	 * 
	 * @return Returns bundle when already available or <code>null</code>.
	 */
	def Bundle getBundle()

	/**
	 * Delivers the symbolic name/ID of this plug-in.
	 * 
	 * @return Returns the symbolic name of the plug-in.
	 */
	def String getSymbolicName()

	/**
	 * Logs the given text as debug entry in the log for this bundle.
	 * 
	 * @param text The text to log.
	 */
	def void debug(String text)

	/**
	 * Logs the given text as information entry in the log for this bundle.
	 * 
	 * @param text The text to log.
	 */
	def void info(String text)

	/**
	 * Logs the given text as warning entry in the status log for this plug-in.
	 * 
	 * @param text The text to log.
	 */
	def void warn(String text)

	/**
	 * Logs the given exception as warning in the status log for this plug-in
	 * trying to resolve a usable message.
	 * 
	 * @param cause The exception to be logged.
	 */
	def void warn(Throwable cause)

	/**
	 * Logs the given text and exception as warning in the ILog status log for this
	 * plug-in.
	 * 
	 * @param text The text to logged.
	 * @param cause The exception to be logged.
	 */
	def void warn(String text, Throwable cause)

	/**
	 * Logs the given text as error in the status log for this plug-in.
	 * 
	 * @param text The text to log.
	 */
	def void error(String text)

	/**
	 * Logs the exception as error in the status log for this plug-in trying to
	 * resolve a usable message.
	 * 
	 * @param cause The exception to be logged.
	 */
	def void error(Throwable cause)

	/**
	 * Logs the given text and the exception as error in the status log for this
	 * plug-in.
	 * 
	 * @param text The text to be logged.
	 * @param cause The exception be to logged.
	 */
	def void error(String text, Throwable cause)
}
