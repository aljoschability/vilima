package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.format.VilimaFormatter
import com.google.common.io.Files
import java.nio.file.Paths
import java.util.Collection
import java.util.List
import java.nio.file.Path
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode

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

class FileFullpathColumn extends FilePathColumn {
	override compare(MkFile file1, MkFile file2) {
		val pathResult = super.compare(file1, file2)
		if(pathResult != 0) {
			return pathResult
		}

		return compareStrings(file1.name, file2.name)
	}

	def private Path getFullPath(MkFile file) {
		Paths::get(file.path, file.name)
	}

	override getString(MkFile file) { file.fullPath.toString }
}

class FilePathColumn extends AbstractStringColumn {
	override compare(MkFile file1, MkFile file2) {
		Paths::get(file1.path).compareTo(Paths::get(file2.path))
	}

	override getString(MkFile file) { file.path }
}

class FileDirectoryColumn extends AbstractStringColumn {
	override getString(MkFile file) { Paths::get(file.path).fileName.toString }
}

class FileSizeColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.size }

	override getString(MkFile file) { VilimaFormatter::fileSize(file.number) }
}

class FileSizeBytesColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.size }

	override getString(MkFile file) { VilimaFormatter::fileSizeBytes(file.number) }
}

class FileDateCreatedColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.dateCreated }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class FileDateModifiedColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file.dateModified }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
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

class SegmentDateColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file?.information?.date }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class SegmentDurationColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTime(file.number) }
}

class SegmentDurationSecondsColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTimeSeconds(file.number) }
}

class SegmentDurationMinutesColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTimeMinutes(file.number) }
}

class TagsMovieCollectionColumn extends AbstractStringColumn {
	override getString(MkFile file) { file.movieCollection }

	def private String getMovieCollection(MkFile file) {
		var MkTagNode foundNode = null

		for (tag : file.tags) {
			val target = tag.target
			if(target != null && target == 70) {
				for (node : tag.nodes) {
					val name = node.name
					if(name != null && name == "TITLE") {
						if(foundNode != null) {
							println(
								'''Found multiple tags for «tag.target»:«tag.targetText» («node.name»=«node.value») in «file.
									name»''')
						} else {
							foundNode = node
						}
					}
				}
			}
		}

		return foundNode?.value
	}
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
	override compare(MkFile file1, MkFile file2) {
		val tracks1 = file1.videoTracks
		val tracks2 = file2.videoTracks

		val widthDiff = compareLongs(tracks1.widthSum, tracks2.widthSum)
		if(widthDiff > 0) {
			return 1
		} else if(widthDiff < 0) {
			return -1
		}

		val heightDiff = compareLongs(tracks1.heightSum, tracks2.heightSum)
		if(heightDiff > 0) {
			return 1
		} else if(heightDiff < 0) {
			return -1
		}

		return 0
	}

	def private static long getWidthSum(Collection<MkTrack> tracks) {
		var result = 0
		for (track : tracks) {
			result += track.videoPixelWidth
		}
		return result
	}

	def private static long getHeightSum(Collection<MkTrack> tracks) {
		var result = 0
		for (track : tracks) {
			result += track.videoPixelHeight
		}
		return result
	}

	def private static List<MkTrack> getVideoTracks(MkFile file) {
		file.tracks.filter[type == MkTrackType::VIDEO].toList
	}

	override getString(MkFile file) {
		val string = new StringBuilder
		val videoTracks = file.videoTracks
		for (var i = 0; i < videoTracks.length; i++) {
			val track = videoTracks.get(i)
			string.append('''«track.videoPixelWidth»×«track.videoPixelHeight»''')
			if(i < videoTracks.length - 1) {
				string.append(", ")
			}
		}

		return string.toString
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
