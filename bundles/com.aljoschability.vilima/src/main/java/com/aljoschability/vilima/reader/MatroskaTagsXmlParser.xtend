package com.aljoschability.vilima.reader

import java.io.File
import java.io.FileInputStream
import java.util.List
import org.apache.commons.io.input.BOMInputStream
import org.eigenbase.xom.DOMWrapper
import org.eigenbase.xom.Parser
import org.eigenbase.xom.XOMUtil

interface IMatroskaTagsXmlParser {
	val TAGS = 'Tags'
	val TAG = 'Tag'

	val TARGETS = 'Targets'
	val TARGET_TYPE = 'TargetType'
	val TARGET_TYPE_VALUE = 'TargetTypeValue'

	val ID_ATTACHMENT = 'AttachmentUID'
	val ID_CHAPTER = 'ChapterUID'
	val ID_EDITION = 'EditionUID'
	val ID_TRACK = 'TrackUID'

	val TAG_LANGUAGE = 'TagLanguage'
	val DEFAULT_LANGUAGE = 'DefaultLanguage'

	val SIMPLE = 'Simple'

	val NAME = 'Name'

	val STRING = 'String'
	val BINARY = 'Binary'
}

class MatroskaTagsXmlParser implements IMatroskaTagsXmlParser {
	val Parser parser

	val List<MTag> tags = newArrayList

	MTag currentTag

	MTargets currentTargets

	MSimple currentSimple

	new() {
		parser = XOMUtil::createDefaultParser
	}

	def parse(File file) {
		tags.clear
		currentTag = null
		currentTargets = null
		currentSimple = null

		val stream = new BOMInputStream(new FileInputStream(file))
		val root = parser.parse(stream)
		stream.close

		parseNodes(root)

		return tags
	}

	private def void parseNodes(DOMWrapper node) {
		switch (node.tagName) {
			case TAGS: {
				// nothing
			}
			case TAG: {
				currentTag = new MTag
				tags += currentTag
			}
			case TARGETS: {
				currentTargets = new MTargets
				currentTag.target = currentTargets
			}
			case TARGET_TYPE_VALUE: {
				currentTargets.typeValue = node.text
			}
			case TARGET_TYPE: {
				currentTargets.type = node.text
			}
			case ID_TRACK: {
				currentTargets.trackUid = node.text
			}
			case SIMPLE: {
				currentSimple = new MSimple
				currentTag.add(currentSimple)
			}
			case NAME: {
				currentSimple.name = node.text
			}
			case STRING: {
				currentSimple.value = node.text
			}
			case TAG_LANGUAGE: {
				currentSimple.language = node.text
			}
			case DEFAULT_LANGUAGE: {
				currentSimple.defaultLanguage = node.text
			}
			default: {
				println('''[WARN] not handled: "«node.tagName»"''')
			}
		}

		for (child : node.elementChildren) {
			parseNodes(child)
		}
	}
}

class MTag {
	val List<MSimple> values = newArrayList
	@Property MTargets target

	def void add(MSimple value) {
		values += value
	}
}

class MTargets {
	@Property String typeValue
	@Property String type
	@Property String trackUid
}

class MSimple {
	@Property String name
	@Property String value
	@Property String language
	@Property String defaultLanguage
}
