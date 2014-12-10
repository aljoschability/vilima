package com.aljoschability.vilima.ui.extensions

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import com.google.common.io.CharStreams
import java.io.File
import java.io.InputStreamReader
import java.nio.file.Paths
import com.google.common.io.Files

interface MkvExtractExtensions {
	val INSTANCE = new MkvExtractExtensionsImpl

	def File toFile(MkFile file)

	//def File getFile(MkAttachment attachment)
	def File extract(MkAttachment attachment)
}

class MkvExtractExtensionsImpl implements MkvExtractExtensions {
	override toFile(MkFile file) {
		Paths::get(file.path, file.name).toFile
	}

	override extract(MkAttachment attachment) {
		val file = File::createTempFile(attachment.name, "." + Files::getFileExtension(attachment.name))
		val command = '''mkvextract attachments "«attachment.file.toFile»" «attachment.id»:"«file»"'''

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
