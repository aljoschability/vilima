package com.aljoschability.vilima.reader

import java.io.File
import java.io.FileInputStream
import java.nio.file.Files
import javax.xml.stream.XMLInputFactory
import javax.xml.stream.XMLStreamConstants
import org.apache.commons.io.input.BOMInputStream

interface IMatroskaTagsExtractor {
	def File extract(File source)

	def void parse(File tags)
}

class MatroskaTagsExtractorImpl implements IMatroskaTagsExtractor {
	val String executable
	val XMLInputFactory factory

	new(String executable) {
		this.executable = executable

		factory = XMLInputFactory::newInstance
	}

	override extract(File source) {
		val target = Files::createTempFile("vilima_tags_", ".xml").toFile
		target.deleteOnExit

		// create parameters
		val params = newLinkedHashMap
		params.put('ui-language', 'en')
		params.put('command-line-charset', 'UTF-8')
		params.put('output-charset', 'UTF-8')
		params.put('redirect-output', target)

		// create command
		val command = '''«executable» tags "«source»"«FOR p : params.keySet» --«p» "«params.get(p)»"«ENDFOR»'''

		// execute command
		val process = Runtime::runtime.exec(command)
		if (process.waitFor == 0) {
			return target
		}

		return null
	}

	override parse(File tags) {
		val is = new BOMInputStream(new FileInputStream(tags))
		val reader = factory.createXMLStreamReader(is)

		while (reader.hasNext) {
			val event = reader.next

			switch (event) {
				case XMLStreamConstants::START_ELEMENT: {
					println(reader.localName)
				}
				case XMLStreamConstants::CHARACTERS: {
					println(reader.text)
				}
			}
		}

		is.close
		reader.close
	}

	def static void main(String[] args) {
		val IMatroskaTagsExtractor e = new MatroskaTagsExtractorImpl(
			'''C:\Program Files (x86)\MKVToolNix\mkvextract.exe''')

		val dir = new File('''C:\Repositories\arda.maglor\eclipse\vilima\__STUFF__\tests''')

		val p = new MatroskaTagsXmlParser

		for (file : dir.listFiles([f, n|n.endsWith(".mkv")])) {
			val tags = e.extract(file)

			if (tags.length > 5) {
				val parsed = p.parse(tags)

				println(parsed)
			}
		}

		println
	}
}

class ExtractTests {
	val static EXECUTABLE = '''C:\Program Files (x86)\MKVToolNix\mkvextract.exe'''

	def String createExtractCommand(File source, File target) {
		val params = newLinkedHashMap

		params.put('ui-language', 'en')
		params.put('command-line-charset', 'UTF-8')
		params.put('output-charset', 'UTF-8')
		params.put('redirect-output', target)

		return '''"«EXECUTABLE»" tags "«source»" «FOR p : params.keySet» --«p» "«params.get(p)»"«ENDFOR»'''
	}
}

class Tests {
	def static void main(String[] args) {
		val dir = new File('''C:\Repositories\arda.maglor\eclipse\vilima\__STUFF__\tests''')

		println('chcp 65001')
		new Tests().run(dir)
		println('pause')
	}

	def void run(File directory) {
		for (file : directory.listFiles([f, n|n.endsWith(".mkv")])) {
			val tagsFile = new File(file.absolutePath + "__before.xml")
			extractTags(file, tagsFile)

		//storeTagsEdit(file, tagsFile)
		}
	}

	def void extractTags(File source, File target) {
		println(new ExtractTests().createExtractCommand(source, target))
	}

	def void storeTagsMerge(File source, File target, File tags) {
	}

	def void storeTagsEdit(File file, File tags) {
		println(new EditTests().createEditCommand(file, tags))
	}
}

class EditTests {
	val static EXECUTABLE = '''C:\Program Files (x86)\MKVToolNix\mkvpropedit.exe'''

	def String createEditCommand(File file, File tags) {
		val params = newLinkedHashMap

		params.put('ui-language', 'en')
		params.put('command-line-charset', 'UTF-8')
		params.put('output-charset', 'UTF-8')

		return '''"«EXECUTABLE»"«FOR p : params.keySet» --«p» "«params.get(p)»"«ENDFOR» "«file»" --tags:"«tags»"'''
	}
}
