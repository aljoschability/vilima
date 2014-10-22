package com.aljoschability.vilima.helpers

import com.aljoschability.vilima.MkFile
import java.util.List
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagEntry

class VilimaTagHelper {
	private new() {
	}

	def static String getValue(MkFile file, String name, int... targets) {
		val values = getValues(file, name, targets)

		if (values.empty) {
			return null
		}

		if (values.size > 1) {
			throw new RuntimeException('''Multiple values for tag "«name»" not supported!''')
		}

		return values.get(0)
	}

	def static List<String> getValues(MkFile file, String name, int... targets) {
		val List<String> values = newArrayList

		for (entry : getEntries(file, name, targets)) {
			values += entry.getValue
		}

		return values
	}

	def static List<MkTagEntry> getEntries(MkFile file, String name, int... targets) {
		val List<MkTagEntry> entries = newArrayList

		for (tag : file.tags) {
			if (targets.contains(tag.getTarget)) {
				for (entry : tag.entries) {
					if (entry.getName == name) {
						entries += entry
					}
				}
			}
		}

		return entries
	}

	def static void setValue(MkFile file, int target, String name, String value) {
		val entries = getEntries(file, name, target)
		if (entries.size > 1) {
			throw new RuntimeException('''more than one entry to edit for "«name»"!''')
		}

		var MkTagEntry entry = null
		if (entries.empty) {
			entry = VilimaFactory::eINSTANCE.createMkTagEntry
			entry.name = name
		} else {
			entry = entries.get(0)
		}

		entry.value = value

		for (tag : file.tags) {
			if (tag.getTarget == target) {
				tag.entries += entry
			}
		}
	}

	def static void removeTags(MkFile file, String name, int... targets) {
		for (tag : file.tags) {
			if (targets.contains(tag.getTarget)) {
				removeEntries(tag, name)
			}
		}
	}

	def private static void removeEntries(MkTag tag, String name) {
		val collection = newArrayList

		for (entry : tag.entries) {
			if (name == entry.getName) {
				collection += entry
			} else {
				for (child : entry.entries) {
					removeEntries(entry, name)
				}
			}
		}

		tag.entries -= collection
	}

	def private static void removeEntries(MkTagEntry entry, String name) {
		val collection = newArrayList

		for (child : entry.entries) {
			if (name == child.getName) {
				collection += entry
			} else {
				for (child2 : entry.entries) {
					removeEntries(child, name)
				}
			}
		}

		entry.entries -= collection
	}
}
