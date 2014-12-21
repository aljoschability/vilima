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
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator
import com.google.common.base.Charsets
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.attribute.BasicFileAttributeView
import java.util.Arrays
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

class MkFileReader {
	extension MatroskaFileSeeker seeker = new MatroskaFileSeeker()

	MkFile file

	@Deprecated
	def private static MkFile newMkFile(Procedure1<MkFile> procedure) {
		val file = VilimaFactory::eINSTANCE.createMkFile
		procedure.apply(file)
		return file
	}

	def MkFile createMkFile(Path path) {
		val attributes = Files::getFileAttributeView(path, BasicFileAttributeView).readAttributes
		file = newMkFile[
			name = path.toFile.name
			path = path.toFile.parent
			dateModified = attributes.lastModifiedTime.toMillis
			dateCreated = attributes.creationTime.toMillis
			size = attributes.size
		]

		seeker.initialize(path)

		skipEbmlHeader()

		seeker.nextElement.parseSegment

		readSeeks()

		seeker.dispose()

		return file
	}

	def private void parseSegment(EbmlElement parent) {
		if(parent.node != MatroskaNode::Segment) {
			throw new RuntimeException("Segment not the second element in the file.")
		}

		seeker.setOffset(seeker.position)

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Cluster: {
					return
				}
				default: {
					seeker.addPositionsParsed(element.offset)
					readSegmentNode(element)
				}
			}

			element.skip
		}
	}

	def private void readSeeks() {
		while(hasSeeks) {
			val element = nextElement(nextSeekPosition)
			readSegmentNode(element)
		}
	}

	def private boolean readSegmentNode(EbmlElement element) {
		switch element.node {
			case SeekHead: {
				element.parseSeekHead
			}
			case Info: {
				element.parseInfo
			}
			case Cluster: {
				println('''trying to read cluster. should not happen!''')
				return false
			}
			case Tracks: {
				element.parseTracks
			}
			case Attachments: {
				element.parseAttachments
			}
			case Chapters: {
				element.parseChapters
			}
			case Tags: {
				element.parseTags
			}
			default: {
			}
		}

		return true
	}

	def private void parseSeekHead(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Seek: {
					element.parseSeek
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void parseSeek(EbmlElement parent) {
		var byte[] id = null
		var long position = -1

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case SeekID: {
					id = element.data.asBytes
				}
				case SeekPosition: {
					position = element.data.asLong
				}
				default: {
				}
			}

			element.skip
		}

		// ignore cluster
		if(!Arrays::equals(MatroskaNode::Cluster.id, id)) {
			seeker.offer(position)
		}
	}

	def private void parseInfo(EbmlElement parent) {
		val information = parent.createMkSegment
		if(information != null) {
			file.information = information
		}
	}

	def private void skipEbmlHeader() {
		val parent = nextElement

		if(parent.node != MatroskaNode::EBML) {
			throw new RuntimeException("EBML root element could not be read.")
		}

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case DocType: {
					val value = element.data.asString

					if(value != "matroska" && value != "webm") {
						throw new RuntimeException("EBML document type cannot be read.")
					}
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private MkSegment createMkSegment(EbmlElement parent) {
		var long timecodeScale = 1000000
		var double duration = -1

		val information = VilimaFactory::eINSTANCE.createMkSegment

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Title: {
					information.title = element.data.asString
				}
				case SegmentUID: {
					information.uid = element.data.asHex
				}
				case PrevUID: {
					information.previousUid = element.data.asHex
				}
				case NextUID: {
					information.nextUid = element.data.asHex
				}
				case SegmentFilename: {
					information.filename = element.data.asString
				}
				case PrevFilename: {
					information.previousFilename = element.data.asString
				}
				case NextFilename: {
					information.nextFilename = element.data.asString
				}
				case DateUTC: {
					information.date = element.data.asTimestamp
				}
				case Duration: {
					duration = element.data.asDouble
				}
				case TimecodeScale: {
					timecodeScale = element.data.asLong
				}
				case MuxingApp: {
					information.muxingApp = element.data.asString
				}
				case WritingApp: {
					information.writingApp = element.data.asString
				}
				default: {
				}
			}

			element.skip
		}

		// TODO: scale duration
		information.duration = duration

		//println('''need to scale timecode: d=«duration»; tcs=«timecodeScale»''')
		return information
	}

	def private void parseTracks(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case TrackEntry: {
					val track = VilimaFactory.eINSTANCE.createMkTrack
					element.fill(track)
					file.tracks += track
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkTrack track) {
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
				case Video: {
					element.fillVideo(track)
				}
				case Audio: {
					element.fillAudio(track)
				}
				default: {
				}
			}

			element.skip
		}

		// fill codec
		if(codecId == "V_MPEG4/ISO/AVC") {
			track.codec = '''«codecId»/«codecPrivate.get(1)»/«codecPrivate.get(3)»'''
		} else if(codecId == "V_MS/VFW/FOURCC") {
			track.codec = '''«codecId»/«new String(Arrays::copyOfRange(codecPrivate, 16, 20))»'''
		} else {
			track.codec = codecId
		}
	}

	def private void fillVideo(EbmlElement parent, MkTrack track) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case PixelWidth: {
					track.videoPixelWidth = element.data.asLong
				}
				case PixelHeight: {
					track.videoPixelHeight = element.data.asLong
				}
				case DisplayWidth: {
					track.videoDisplayWidth = element.data.asLong
				}
				case DisplayHeight: {
					track.videoDisplayHeight = element.data.asLong
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fillAudio(EbmlElement parent, MkTrack track) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
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

	def private void parseAttachments(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case AttachedFile: {
					val attachment = VilimaFactory::eINSTANCE.createMkAttachment
					attachment.id = file.attachments.size
					element.fill(attachment)

					file.attachments += attachment
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkAttachment attachment) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case FileUID: {
					attachment.uid = element.data.asLong
				}
				case FileDescription: {
					attachment.description = element.data.asString
				}
				case FileName: {
					attachment.name = element.data.asString
				}
				case FileMimeType: {
					attachment.mimeType = element.data.asString
				}
				case FileData: {
					attachment.size = element.size
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void parseChapters(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case EditionEntry: {
					val edition = VilimaFactory::eINSTANCE.createMkEdition()
					element.fill(edition)

					file.editions += edition
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkEdition edition) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case EditionUID: {
					edition.uid = element.data.asLong
				}
				case EditionFlagDefault: {
					edition.flagDefault = element.data.asBoolean
				}
				case EditionFlagHidden: {
					edition.flagHidden = element.data.asBoolean
				}
				case EditionFlagOrdered: {
					edition.flagOrdered = element.data.asBoolean
				}
				case ChapterAtom: {
					val chapter = VilimaFactory::eINSTANCE.createMkChapter

					element.fill(chapter)

					edition.chapters += chapter
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkChapter chapter) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case ChapterUID: {
					chapter.uid = element.data.asLong
				}
				case ChapterTimeStart: {
					chapter.timeStart = element.data.asLong
				}
				case ChapterTimeEnd: {
					chapter.timeEnd = element.data.asLong
				}
				case ChapterFlagHidden: {
					chapter.flagHidden = element.data.asBoolean
				}
				case ChapterFlagEnabled: {
					chapter.flagEnabled = element.data.asBoolean
				}
				case ChapterDisplay: {
					val text = VilimaFactory.eINSTANCE.createMkChapterText()

					element.fill(text)

					chapter.texts += text
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkChapterText text) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case ChapString: {
					text.text = element.data.asString
				}
				case ChapLanguage: {
					text.languages += element.data.asString
				}
				default: {
				}
			}

			element.skip
		}

		// add default language when nothing was set
		if(text.languages.empty) {
			text.languages += "eng"
		}
	}

	def private void parseTags(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Tag: {
					val tag = VilimaFactory::eINSTANCE.createMkTag

					element.fill(tag)

					file.tags += tag
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private fill(EbmlElement parent, MkTag tag) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Targets: {
					element.parseTagTargets(tag)
				}
				case SimpleTag: {
					val node = VilimaFactory::eINSTANCE.createMkTagNode

					element.fill(node)

					tag.nodes += node
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void parseTagTargets(EbmlElement parent, MkTag tag) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element. node {
				case TargetTypeValue: {
					tag.target = element.data.asLong
				}
				case TargetType: {
					tag.targetText = element.data.asString
				}
				case TagTrackUID: {
					//XXX: println(this + "added non-global tag")
				}
				case TagEditionUID: {
					//XXX: println(this + "added non-global tag")
				}
				case TagChapterUID: {
					//XXX: println(this + "added non-global tag")
				}
				case TagAttachmentUID: {
					//XXX: println(this + "added non-global tag")
				}
				default: {
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkTagNode node) {
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
					val child = VilimaFactory::eINSTANCE.createMkTagNode

					element.fill(child)

					node.nodes += child
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
	}

	def MkFile read(URI uri) {
		if(uri.file) {
			return createMkFile(Paths::get(uri.toFileString))
		}
		return null
	}

	def void close() {
		dispose()
	}

	/*** END AS-* METHODS **************************************/
	// TODO: use extension method here
	def private static long asLong(byte[] data) {
		return MkResourceReaderByteOperator::INSTANCE.bytesToLongUnsigned(data)
	}

	def private static long asLong(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::UINTEGER) {
			return element.data.asLong
		}

		throw new RuntimeException
	}

	def private static MkTrackType asMkTrackType(EbmlDataElement element) {
		switch element.asLong as int {
			case 0x01: MkTrackType::VIDEO
			case 0x02: MkTrackType::AUDIO
			case 0x03: MkTrackType::COMPLEX
			case 0x10: MkTrackType::LOGO
			case 0x11: MkTrackType::SUBTITLE
			case 0x20: MkTrackType::CONTROL
			default: throw new RuntimeException("could not convert track type")
		}
	}

	def private static boolean asBoolean(EbmlDataElement element) {
		element.asLong == 1
	}

	def private static int asInteger(byte[] data) {
		data.asLong as int
	}

	def private static double asDouble(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::FLOAT) {
			if(element.size == 4) {
				return Float::intBitsToFloat(element.data.asInteger)
			}

			if(element.size == 8) {
				return Double::longBitsToDouble(element.data.asLong)
			}
		}
		throw new RuntimeException
	}

	def private static String asString(EbmlDataElement element) {
		switch element.node.type {
			case ASCII:
				return new String(element.data, Charsets::US_ASCII)
			case STRING:
				return new String(element.data, Charsets::UTF_8)
			default: {
			}
		}
	}

	def private static byte[] asBytes(EbmlDataElement element) {
		element.data
	}

	// TODO: use extension method here
	def private static Long asTimestamp(EbmlDataElement element) {
		MkResourceReaderByteOperator::INSTANCE.readTimestamp(element.data)
	}

	// TODO: use extension method here
	def private static String asHex(EbmlDataElement element) {
		MkResourceReaderByteOperator::INSTANCE.bytesToHex(element.data)
	}

/*** END AS-* METHODS **************************************/
}
