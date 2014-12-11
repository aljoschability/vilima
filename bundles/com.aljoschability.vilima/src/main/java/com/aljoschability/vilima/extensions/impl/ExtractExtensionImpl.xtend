package com.aljoschability.vilima.extensions.impl

import com.aljoschability.vilima.Activator
import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.extensions.ExtractExtension
import com.aljoschability.vilima.extensions.MkFileExtension
import com.google.common.io.CharStreams
import com.google.common.io.Files
import java.io.File
import java.io.InputStreamReader

class ExtractExtensionImpl implements ExtractExtension {
	override extract(MkAttachment attachment) {
		val file = File::createTempFile(attachment.name, "." + Files::getFileExtension(attachment.name))
		val command = '''mkvextract attachments "«MkFileExtension::INSTANCE.toFile(attachment.file)»" «attachment.id»:"«file»"'''

		val process = Runtime::getRuntime.exec(command)
		if(process.waitFor != 0) {
			file.delete

			// report the error
			val message = CharStreams::toString(new InputStreamReader(process.inputStream))
			Activator::get.error(message)
		}

		return file
	}
}
