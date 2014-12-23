package com.aljoschability.vilima.reading

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkSegment
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.extensions.MatroskaFileReaderExtension
import java.util.Arrays
import java.util.concurrent.TimeUnit

class MatroskaFileBuilder {
	val extension MatroskaFileReaderExtension = MatroskaFileReaderExtension::INSTANCE

	val extension MatroskaFileSeeker seeker

	val MkFile file

	new(MatroskaFileSeeker seeker, MkFile file) {
		this.seeker = seeker
		this.file = file
	}

	def void readSegmentNode(EbmlElement element) {
		switch element.node {
			case Info: {
				element.handleInfo
			}
			case Tracks: {
				element.handleTracks
			}
			case Attachments: {
				element.handleAttachments
			}
			case Chapters: {
				element.handleChapters
			}
			case Tags: {
				element.handleTags
			}
			default: {
			}
		}
	}

	/**
	 * This processes the main element <code>Info</code>.
	 */
	def private void handleInfo(EbmlElement parent) {
		file.information = parent.createMkInfo
	}

	def private MkSegment createMkInfo(EbmlElement parent) {
		val result = VilimaFactory::eINSTANCE.createMkSegment

		// needed for actual value
		var long durationScale = 1000000
		var double durationValue = -1

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Title: {
					result.title = element.data.asString
				}
				case SegmentUID: {
					result.uid = element.data.asHex
				}
				case PrevUID: {
					result.previousUid = element.data.asHex
				}
				case NextUID: {
					result.nextUid = element.data.asHex
				}
				case SegmentFilename: {
					result.filename = element.data.asString
				}
				case PrevFilename: {
					result.previousFilename = element.data.asString
				}
				case NextFilename: {
					result.nextFilename = element.data.asString
				}
				case DateUTC: {
					result.date = element.data.asTimestamp
				}
				case Duration: {
					durationValue = element.data.asDouble
				}
				case TimecodeScale: {
					durationScale = element.data.asLong
				}
				case MuxingApp: {
					result.muxingApp = element.data.asString
				}
				case WritingApp: {
					result.writingApp = element.data.asString
				}
				default: {
				}
			}

			element.skip
		}

		// scale duration
		val durationNs = TimeUnit::NANOSECONDS.toMillis((durationValue * durationScale) as long)
		result.duration = durationNs.doubleValue

		return result
	}

	/**
	 * This processes the main element <code>Tracks</code>.
	 */
	def private void handleTracks(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case TrackEntry: {
					file.tracks += element.createMkTrack
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private MkTrack createMkTrack(EbmlElement parent) {
		val track = VilimaFactory.eINSTANCE.createMkTrack

		// for value calculation
		var String codecId = null
		var byte[] codecPrivate = null

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case TrackNumber: {
					track.number = element.data.asLong
				}
				case TrackUID: {
					track.uid = element.data.asLong
				}
				case TrackType: {
					track.type = element.data.asMkTrackType
				}
				case FlagEnabled: {
					track.flagEnabled = element.data.asBoolean
				}
				case FlagDefault: {
					track.flagDefault = element.data.asBoolean
				}
				case FlagForced: {
					track.flagForced = element.data.asBoolean
				}
				case FlagLacing: {
					track.flagLacing = element.data.asBoolean
				}
				case Name: {
					track.name = element.data.asString
				}
				case Language: {
					track.language = element.data.asString
				}
				case CodecID: {
					codecId = element.data.asString
				}
				case CodecPrivate: {
					codecPrivate = element.data.asBytes
				}
				case Audio,
				case Video: {
					element.fillMkTrackDetails(track)
				}
				default: {
				}
			}

			element.skip
		}

		// fill codec
		track.codec = if(codecId == "V_MPEG4/ISO/AVC") {
			'''«codecId»/«codecPrivate.get(1)»/«codecPrivate.get(3)»'''
		} else if(codecId == "V_MS/VFW/FOURCC") {
			'''«codecId»/«new String(Arrays::copyOfRange(codecPrivate, 16, 20))»'''
		} else {
			codecId
		}

		return track
	}

	def private void fillMkTrackDetails(EbmlElement parent, MkTrack track) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case PixelWidth: {
					track.videoPixelWidth = element.data.asLong
				}
				case PixelHeight: {
					track.videoPixelHeight = element.data.asLong
				}
				case FlagInterlaced: {
					track.videoFlagInterlaced = element.data.asBoolean
				}
				case SamplingFrequency: {
					track.audioSamplingFrequency = element.data.asDouble
				}
				case Channels: {
					track.audioChannels = element.data.asLong
				}
				default: {
				}
			}

			element.skip
		}
	}

	/**
	 * This processes the main element <code>Attachments</code>.
	 */
	def private void handleAttachments(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case AttachedFile: {
					file.attachments += element.createMkAttachment(file.attachments.size)
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private MkAttachment createMkAttachment(EbmlElement parent, int id) {
		val result = VilimaFactory::eINSTANCE.createMkAttachment
		result.id = id

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case FileUID: {
					result.uid = element.data.asLong
				}
				case FileDescription: {
					result.description = element.data.asString
				}
				case FileName: {
					result.name = element.data.asString
				}
				case FileMimeType: {
					result.mimeType = element.data.asString
				}
				case FileData: {
					result.size = element.size
				}
				default: {
				}
			}

			element.skip
		}
		return result
	}

	/**
	 * This processes the main element <code>Chapters</code>.
	 */
	def private void handleChapters(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case EditionEntry: {
					file.editions += element.createMkEdition
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private MkEdition createMkEdition(EbmlElement parent) {
		val result = VilimaFactory::eINSTANCE.createMkEdition

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case EditionUID: {
					result.uid = element.data.asLong
				}
				case EditionFlagDefault: {
					result.flagDefault = element.data.asBoolean
				}
				case EditionFlagHidden: {
					result.flagHidden = element.data.asBoolean
				}
				case EditionFlagOrdered: {
					result.flagOrdered = element.data.asBoolean
				}
				case ChapterAtom: {
					result.chapters += element.createMkChapter
				}
				default: {
				}
			}

			element.skip
		}

		return result
	}

	def private MkChapter createMkChapter(EbmlElement parent) {
		val result = VilimaFactory::eINSTANCE.createMkChapter

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case ChapterUID: {
					result.uid = element.data.asLong
				}
				case ChapterTimeStart: {
					result.timeStart = element.data.asLong
				}
				case ChapterTimeEnd: {
					result.timeEnd = element.data.asLong
				}
				case ChapterFlagHidden: {
					result.flagHidden = element.data.asBoolean
				}
				case ChapterFlagEnabled: {
					result.flagEnabled = element.data.asBoolean
				}
				case ChapterDisplay: {
					result.texts += element.createMkChapterText
				}
				default: {
				}
			}

			element.skip
		}

		return result
	}

	def private MkChapterText createMkChapterText(EbmlElement parent) {
		val result = VilimaFactory::eINSTANCE.createMkChapterText

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case ChapString: {
					result.text = element.data.asString
				}
				case ChapLanguage: {
					result.languages += element.data.asString
				}
				default: {
				}
			}

			element.skip
		}

		// add default language when nothing was set
		if(result.languages.empty) {
			result.languages += "eng"
		}

		return result
	}

	/**
	 * This processes the main element <code>Tags</code>.
	 */
	def private void handleTags(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Tag: {
					file.tags += element.createMkTag
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private MkTag createMkTag(EbmlElement parent) {
		val tag = VilimaFactory::eINSTANCE.createMkTag

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Targets: {
					element.fillMkTagTargets(tag)
				}
				case SimpleTag: {
					tag.nodes += element.createMkTagNode
				}
				default: {
				}
			}

			element.skip
		}

		return tag
	}

	def private void fillMkTagTargets(EbmlElement parent, MkTag tag) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case TargetTypeValue: {
					tag.target = element.data.asLong
				}
				case TargetType: {
					tag.targetText = element.data.asString
				}
				default: {
					// TODO: TagTrackUID happens often
				}
			}

			element.skip
		}
	}

	def private MkTagNode createMkTagNode(EbmlElement parent) {
		val node = VilimaFactory::eINSTANCE.createMkTagNode

		while(parent.hasNext) {
			val element = parent.nextChild
			switch element.node {
				case TagName: {
					node.name = element.data.asString
				}
				case TagString: {
					node.value = element.data.asString
				}
				case SimpleTag: {
					node.nodes += element.createMkTagNode
				}
				case TagLanguage: {
					node.language = element.data.asString
				}
				case TagDefault: {
					node.languageDefault = element.data.asBoolean
				}
				default: {
				}
			}

			element.skip
		}

		return node
	}
}
