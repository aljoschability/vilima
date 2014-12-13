package com.aljoschability.vilima.reading

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkInformation
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.VilimaFactory
import com.aljoschability.vilima.helpers.MkReaderByter
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.attribute.BasicFileAttributeView
import java.util.Arrays
import java.util.Collection
import java.util.LinkedList
import java.util.Queue

class MkFileParserSeeker {
	val MatroskaFileSeeker seeker

	public long offset
	public Queue<Long> seeks
	public Collection<Long> positionsParsed

	new(Path path) {
		seeker = new MatroskaFileSeeker(path)

		seeks = new LinkedList
		positionsParsed = newArrayList
		offset = -1
	}

	def void dispose() {
		seeker.dispose()

		seeks = null
		positionsParsed = null
		offset = -1
	}

	def offer(long position) {
		seeks.offer(position + offset)
	}

	def setOffset(long offset) {
		this.offset = offset
	}

	def addPositionsParsed(long position) {
		positionsParsed += position
		seeks.remove(position)
	}

	def nextElement(Long position) {
		seeker.nextElement(position)
	}

	def nextElement() {
		seeker.nextElement()
	}

	def getPosition() {
		seeker.position
	}

	def void skip(EbmlElement element) {
		seeker.skip(element)
	}

	def byte[] readBytes(EbmlElement element) {
		seeker.readBytes(element as EbmlDataElement)
	}

	def long readLong(EbmlElement element) {
		seeker.readInteger(element as EbmlDataElement)
	}

	def double readDouble(EbmlElement element) {
		seeker.readDouble(element as EbmlDataElement)
	}

	def long readTimestamp(EbmlElement element) {
		seeker.readTimestamp(element as EbmlDataElement)
	}

	def String readString(EbmlElement element) {
		seeker.readString(element as EbmlDataElement)
	}

	def EbmlElement nextChild(EbmlElement element) {
		return seeker.nextChild(element as EbmlMasterElement)
	}

	def int readInt(EbmlElement element) {
		seeker.readInteger(element as EbmlDataElement) as int
	}

	def MkFile newMkFile(Path path) {
		val file = path.toFile
		println('''### «file.name»''')

		val result = VilimaFactory::eINSTANCE.createMkFile()

		result.name = file.name
		result.path = file.parent

		val attributes = Files::getFileAttributeView(file.toPath, BasicFileAttributeView).readAttributes
		result.dateModified = attributes.lastModifiedTime.toMillis
		result.dateCreated = attributes.creationTime.toMillis
		result.size = attributes.size

		return result
	}

	def MatroskaNode getNode(EbmlElement element) {
		MatroskaNode::get(element.id)
	}

	def long offset(EbmlElement element) {
		return seeker.position - element.headerSize
	}

	def String readHex(EbmlElement element) {
		MkReaderByter::bytesToHex(element.readBytes)
	}

	def MkTrackType readMkTrackType(EbmlElement element) {
		MkReaderByter::convertTrackType(element.readLong as byte)
	}

	def boolean hasNext(EbmlElement element) {
		if(element instanceof EbmlMasterElement) {
			return element.hasNext
		}

		return false
	}
}

class MatroskaFileReader {
	extension MkFileParserSeeker seeker

	MkFile file

	int attachmentsCount

	def MkFile readFile(Path path) {
		init(path)

		readFile()

		readSeeks()

		dispose()

		return file
	}

	def private void readSeeks() {
		while(!seeker.seeks.empty) {
			val position = seeker.seeks.poll
			if(!seeker.positionsParsed.contains(position)) {
				val element = seeker.nextElement(position)
				readSegmentNode(element)
			} else {
				println('''the position has already been parsed!''')
			}
		}
	}

	def private void init(Path path) {
		seeker = new MkFileParserSeeker(path)

		file = path.newMkFile

		attachmentsCount = 0
	}

	def private void dispose() {
		seeker.dispose()
	}

	def private void readFile() {
		seeker.nextElement.parseEbml

		seeker.nextElement.parseSegment
	}

	def private void parseEbml(EbmlElement parent) {
		if(!MatroskaNode::EBML.matches(parent)) {
			throw new RuntimeException("EBML root element could not be read.")
		}

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case DocType: {
					val value = element.readString

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

	def private void parseSegment(EbmlElement parent) {
		if(!MatroskaNode::Segment.matches(parent)) {
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
					id = element.readBytes
				}
				case SeekPosition: {
					position = element.readLong
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
		val information = parent.createInfo
		if(information != null) {
			file.information = information
		}
	}

	def private MkInformation createInfo(EbmlElement parent) {
		val information = VilimaFactory::eINSTANCE.createMkInformation

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Title: {
					information.title = element.readString
				}
				case SegmentUID: {
					information.uid = element.readHex
				}
				case PrevUID: {
					information.previousUid = element.readHex
				}
				case NextUID: {
					information.nextUid = element.readHex
				}
				case SegmentFilename: {
					information.filename = element.readString
				}
				case PrevFilename: {
					information.previousFilename = element.readString
				}
				case NextFilename: {
					information.nextFilename = element.readString
				}
				case DateUTC: {
					information.date = element.readTimestamp
				}
				case Duration: {
					information.duration = element.readDouble
				}
				case MuxingApp: {
					information.muxingApp = element.readString
				}
				case WritingApp: {
					information.writingApp = element.readString
				}
				default: {
				}
			}

			element.skip
		}

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
					track.number = element.readInt
				}
				case TrackUID: {
					track.uid = element.readLong
				}
				case TrackType: {
					track.type = element.readMkTrackType
				}
				case Name: {
					track.name = element.readString
				}
				case Language: {
					track.language = element.readString
				}
				case CodecID: {
					codecId = element.readString
				}
				case CodecPrivate: {
					codecPrivate = element.readBytes
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
					track.videoPixelWidth = element.readInt
				}
				case PixelHeight: {
					track.videoPixelHeight = element.readInt
				}
				case DisplayWidth: {
					track.videoDisplayWidth = element.readInt
				}
				case DisplayHeight: {
					track.videoDisplayHeight = element.readInt
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
					track.audioSamplingFrequency = element.readDouble
				}
				case Channels: {
					track.audioChannels = element.readInt
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
					attachmentsCount++

					val attachment = VilimaFactory::eINSTANCE.createMkAttachment
					attachment.id = attachmentsCount
					element.fill(attachment)

					file.attachments += attachment
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
					attachment.uid = element.readLong
				}
				case FileDescription: {
					attachment.description = element.readString
				}
				case FileName: {
					attachment.name = element.readString
				}
				case FileMimeType: {
					attachment.mimeType = element.readString
				}
				case FileData: {
					attachment.size = element.size
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
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkEdition edition) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case EditionUID: {
					edition.uid = element.readLong
				}
				case ChapterAtom: {
					val chapter = VilimaFactory::eINSTANCE.createMkChapter

					element.fill(chapter)

					edition.chapters += chapter
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkChapter chapter) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case ChapterTimeStart: {
					chapter.start = element.readLong
				}
				case ChapterDisplay: {
					val text = VilimaFactory.eINSTANCE.createMkChapterText()

					element.fill(text)

					chapter.texts += text
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
					text.text = element.readString
				}
				case ChapLanguage: {
					text.languages += element.readString
				}
				case ChapCountry: {
					// TODO: ChapCountry not used
				}
			}

			element.skip
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
			}

			element.skip
		}
	}

	def private void parseTagTargets(EbmlElement parent, MkTag tag) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element. node {
				case TargetTypeValue: {
					tag.target = element.readInt
				}
				case TargetType: {
					tag.targetText = element.readString
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
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkTagNode node) {
		while(parent.hasNext) {
			val element = parent.nextChild
			switch element.node {
				case TagName: {
					node.name = element.readString
				}
				case TagString: {
					node.value = element.readString
				}
				case SimpleTag: {
					val child = VilimaFactory::eINSTANCE.createMkTagNode

					element.fill(child)

					node.nodes += child
				}
			}

			element.skip
		}
	}
}
