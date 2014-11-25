package com.aljoschability.vilima.ui.preferences

import com.aljoschability.vilima.ui.Activator
import java.util.Map
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer

class VilimaPreferenceInitializer extends AbstractPreferenceInitializer {
	override initializeDefaultPreferences() {
		val store = Activator::get.preferenceStore

		val entries = PreferenceSupplier::getInitializationEntries
		for (key : entries.keySet) {
			store.setDefault(key, entries.get(key))
		}
	}
}

class PreferenceSupplier {
	static val P_STRING = "s"
	static val DEF_STRING = "s"
	static val P_BOOLEAN = "s"
	static val DEF_BOOLEAN = false
	static val P_DOUBLE = "s"
	static val DEF_DOUBLE = 0.1d
	static val P_INT = "s"
	static val DEF_INT = 5

	def static Map<String, String> getInitializationEntries() {
		val entries = newLinkedHashMap

		entries.put(P_STRING, DEF_STRING)
		entries.put(P_BOOLEAN, Boolean.toString(DEF_BOOLEAN))
		entries.put(P_DOUBLE, Double.toString(DEF_DOUBLE))
		entries.put(P_INT, Integer.toString(DEF_INT))

		return entries
	}
}
