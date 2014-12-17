package com.aljoschability.vilima.extensions.impl

import com.aljoschability.vilima.Activator
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkInformation
import com.aljoschability.vilima.extensions.MkFileExtension
import com.aljoschability.vilima.extensions.ModifyExtension
import com.google.common.io.CharStreams
import java.io.InputStreamReader

class ModifyExtensionImpl implements ModifyExtension {
	override writeAll(MkInformation information) {
		val command = create(information.file)
		command.append(''' --edit info''')

		// title
		command.set("title", information.title)

		// segment-filename
		command.set("segment-filename", information.filename)

		// prev-filename
		command.set("prev-filename", information.previousFilename)

		// next-filename
		command.set("next-filename", information.nextFilename)

		// segment-uid 
		command.set("segment-uid", information.uid)

		// prev-uid
		command.set("prev-uid", information.previousUid)

		// next-uid
		command.set("next-uid", information.nextUid)

		execute(command.toString)
	}

	override writeInfo(MkFile file, String name, String value) {
		val command = create(file)
		command.append(''' --edit info''')

		command.set(name, value)

		execute(command.toString)
	}

	def private static create(MkFile file) {
		new StringBuilder('''mkvpropedit "«MkFileExtension::INSTANCE.toFile(file)»"''')
	}

	def private static set(StringBuilder builder, String name, String rawValue) {
		val value = rawValue?.trim
		if(value.nullOrEmpty) {
			builder.append(''' --delete «name»''')
		} else {
			builder.append(''' --set "«name»=«value»"''')
		}
	}

	def private static boolean execute(String command) {
		val process = Runtime::getRuntime.exec(command)
		if(process.waitFor != 0) {

			// report the error
			val message = CharStreams::toString(new InputStreamReader(process.inputStream))
			Activator::get.error(message)
			return false
		}
		return true
	}
}
