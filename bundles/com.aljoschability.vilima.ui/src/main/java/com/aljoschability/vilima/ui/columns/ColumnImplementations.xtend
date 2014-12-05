package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.format.VilimaFormatter
import com.google.common.io.Files
import java.nio.file.Paths

class FileNameColumn extends AbstractStringColumn {
	override getString(MkFile file) { file.name }

	override protected isEditable() { true }

	override protected set(MkFile file, String string) {
		val oldFile = Paths::get(file.path, file.name).toFile
		val newFile = Paths::get(file.path, string).toFile

		// only if not equal name + not existing
		if(oldFile != newFile && !newFile.exists) {
			Files::move(oldFile, newFile)

			file.name = string
			return true
		}

		return false
	}
}

class FilePathColumn extends AbstractStringColumn {
	override getString(MkFile file) { file.path }
}

class SegmentTitleColumn extends AbstractStringColumn {
	override getString(MkFile file) { file?.information?.title }

	override protected isEditable() { true }

	override protected set(MkFile file, String value) {
		if(file.string != value) {

			//file.information.title = newValue as String
			println('''Store segment title: "«file.string»" ==> "«value»".''')

			return true
		}
		return false
	}
}

class SegmentUidColumn extends AbstractStringColumn {
	override protected useMonospaceFont() { true }

	override getString(MkFile file) { file?.information?.uid }
}

class SegmentPreviousUidColumn extends AbstractStringColumn {
	override protected useMonospaceFont() { true }

	override getString(MkFile file) { file?.information?.previousUid }
}

class SegmentNextUidColumn extends AbstractStringColumn {
	override protected useMonospaceFont() { true }

	override getString(MkFile file) { file?.information?.nextUid }
}

class SegmentWritingAppColumn extends AbstractStringColumn {
	override getString(MkFile file) { file?.information?.writingApp }
}

class SegmentMuxingAppColumn extends AbstractStringColumn {
	override getString(MkFile file) { file?.information?.muxingApp }
}

class AttachmentCoverColumn extends AbstractStringColumn {
	val static COVERS = #["cover.jpg", "small_cover.jpg", "cover_land.jpg", "small_cover_land.jpg"]

	override getString(MkFile file) {
		for (a : file.attachments) {
			if(COVERS.contains(a.name)) {
				return "YES"
			}
		}
		return "NO"
	}
}

class TrackVideoResolutionColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		for (track : file.tracks) {
			if(track.type == MkTrackType::VIDEO) {
				return String.valueOf(track.videoPixelWidth)
			}
		}
		return ""
	}
}

class TrackCodecsColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		val text = new StringBuilder

		for (var i = 0; i < file.tracks.size; i++) {
			val track = file.tracks.get(i)

			text.append(track.codecId)

			if(i < file.tracks.size - 1) {
				text.append(", ")
			}
		}
		return text.toString
	}
}

class TrackVideoCodecsColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		val text = new StringBuilder

		for (var i = 0; i < file.tracks.size; i++) {
			val track = file.tracks.get(i)

			if(track.type == MkTrackType::VIDEO) {
				text.append(VilimaFormatter::getTrackInfo(track))
			}
		}
		return text.toString
	}
}

class TagsContentTypeColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		var String text = null
		for (tag : file.tags) {
			for (node : tag.nodes) {
				if(node.name == "CONTENT_TYPE") {
					text = node.value
				}
			}
		}
		return text
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag[CONTENT_TYPE]: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class FileSizeColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.size }

	override getString(MkFile file) { VilimaFormatter::fileSize(file.number) }
}

class FileDateCreatedColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.dateCreated }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class FileDateModifiedColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.dateModified }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class SegmentDateColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file?.information?.date }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class SegmentDurationColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTime(file.number) }
}
