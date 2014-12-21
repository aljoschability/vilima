package com.aljoschability.vilima.writing

import com.aljoschability.vilima.MkFile
import com.google.common.base.Charsets
import com.google.common.io.Files
import java.io.File
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode

class TagsWriter {
	StringBuilder builder

	def void write(MkFile file) {
		val started = System.nanoTime

		builder = new StringBuilder

		writeHeader()

		start("Tags", 0)

		for (tag : file.tags) {
			start("Tag", 1)
			writeTag(tag, 2)
			end("Tag", 1)
		}

		end("Tags", 0)

		val realFile = new File(file.path + File::separator + file.name)
		val tagFile = new File(realFile + ".xml")
		Files::write(builder.toString, tagFile, Charsets::UTF_8)

		val command = '''mkvpropedit "«realFile»" --tags global:"«tagFile»"'''
		val process = Runtime::getRuntime.exec(command)

		if(process.waitFor == 0) {
			//tagFile.delete
		}

		val elapsed = (System.nanoTime - started) / 1000000d
		println('''run[«process.exitValue»] command "«command»" in «elapsed»ms''')
	}

	def private void writeHeader() {
		builder.append('''<?xml version="1.0"?>''')
		builder.append("\n")
	}

	def private void writeTag(MkTag tag, int indent) {
		writeTagTargets(tag, indent)

		for (entry : tag.nodes) {
			writeTagEntry(entry, indent)
		}
	}

	def private void writeTagEntry(MkTagNode entry, int indent) {
		start("Simple", indent)
		appendTag("Name", entry.getName, indent + 1)
		appendTag("String", entry.getValue, indent + 1)
		appendTag("TagLanguage", entry.getLanguage, indent + 1)
		appendTag("DefaultLanguage", 1, indent + 1)
		end("Simple", indent)
	}

	def private void writeTagTargets(MkTag tag, int indent) {
		start("Targets", indent)
		appendTag("TargetTypeValue", tag.target, indent + 1)
		appendTag("TargetType", tag.targetText, indent + 1)
		end("Targets", indent)
	}

	def private void appendTag(String name, Object value, int indent) {
		indent(indent)
		builder.append('''<«name»>«value»</«name»>''')
		builder.append("\n")
	}

	def private void start(String name, int indent) {
		indent(indent)
		builder.append('''<«name»>''')
		builder.append("\n")
	}

	def private void end(String name, int indent) {
		indent(indent)
		builder.append('''</«name»>''')
		builder.append("\n")
	}

	def private void indent(int indent) {
		for (var i = 0; i < indent; i++) {
			builder.append("\t")
		}
	}
}
