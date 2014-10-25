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
import com.aljoschability.vilima.helpers.MatroskaReader
import java.io.File
import java.util.Arrays
import java.util.Collection
import com.aljoschability.vilima.helpers.MkReaderByter

class MatroskaFileReader {
	extension ReaderHelper helper = new ReaderHelper

	MkFile result
	MatroskaFileSeeker seeker

	Collection<Long> positionsNeeded
	Collection<Long> positionsParsed
	long seekOffset

	def MkFile readFile(File file) {
		init(file)

		readFile()

		readSeeks()

		dispose()

		return result
	}

	def private void readSeeks() {

		// remove already read elements
		for (Long position : positionsParsed) {
			positionsNeeded.remove(position)
		}

		// read the referenced elements
		for (Long position : positionsNeeded) {
			val element = seeker.nextElement(position)
			readSegmentNode(element as EbmlMasterElement)
		}
	}

	def private void init(File file) {
		result = file.createMkFile

		positionsNeeded = newArrayList
		positionsParsed = newArrayList
		seekOffset = -1

		seeker = new MatroskaFileSeeker(file.toPath)
	}

	def private void dispose() {
		seeker.dispose()

		positionsNeeded = null
		positionsParsed = null
		seekOffset = -1
	}

	def private void readFile() {
		var element = seeker.nextElement();
		if (!MatroskaNode::EBML.matches(element)) {
			throw new RuntimeException("EBML root element could not be read.")
		}

		readDocType(element as EbmlMasterElement)

		element = seeker.nextElement()
		if (!MatroskaNode::Segment.matches(element)) {
			throw new RuntimeException("Segment not the second element in the file.")
		}

		readSegment(element as EbmlMasterElement)
	}

	def private void readDocType(EbmlMasterElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::DocType.id: {
					val value = element.readString

					if (value != "matroska" && value != "webm") {
						throw new RuntimeException("EBML document type cannot be read.")
					}
				}
			}

			element.skip
		}
	}

	def private void readSegment(EbmlMasterElement parent) {
		seekOffset = seeker.position

		var EbmlElement element = null
		while ((element = seeker.nextChild(parent)) != null) {
			if (element instanceof EbmlMasterElement) {
				if (!readSegmentNode(element as EbmlMasterElement)) {
					return;
				}
			}

			element.skip
		}
	}

	def private boolean readSegmentNode(EbmlMasterElement element) {
		positionsParsed += element.offset

		switch element.id {
			case MatroskaNode::SeekHead.id: {
				element.parseSeekHead
			}
			case MatroskaNode::Info.id: {
				if (result.information != null) {
					throw new RuntimeException("Info already exists.")
				}

				result.information = VilimaFactory.eINSTANCE.createMkInformation

				element.fill(result.information)
			}
			case MatroskaNode::Cluster.id: {
				return false
			}
			case MatroskaNode::Tracks.id: {
				element.parseTracks
			}
			case MatroskaNode::Attachments.id: {
				element.parseAttachments
			}
			case MatroskaNode::Chapters.id: {
				element.parseChapters
			}
			case MatroskaNode::Tags.id: {
				element.parseTags
			}
		}

		return true
	}

	def private void parseSeekHead(EbmlElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::Seek.id: {
					element.parseSeek
				}
			}

			element.skip
		}
	}

	def private void parseSeek(EbmlElement parent) {
		var byte[] id = null
		var long position = -1

		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::SeekID.id: {
					id = element.readBytes
				}
				case MatroskaNode::SeekPosition.id: {
					position = element.readLong
				}
			}

			element.skip
		}

		// ignore cluster
		if (!Arrays::equals(MatroskaNode::Cluster.id, id)) {
			positionsNeeded += (position + seekOffset)
		}
	}

	def private void fill(EbmlElement parent, MkInformation information) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::Title.id: {
					information.title = element.readString
				}
				case MatroskaNode::SegmentUID.id: {
					information.uid = element.readHex
				}
				case MatroskaNode::DateUTC.id: {

					// XXX: this should use the "international format"...
					information.date = seeker.readTimestamp(element as EbmlDataElement)
				}
				case MatroskaNode::MuxingApp.id: {
					information.muxingApp = element.readString
				}
				case MatroskaNode::WritingApp.id: {
					information.writingApp = element.readString
				}
				case MatroskaNode::Duration.id: {
					information.duration = element.readDouble
				}
				case MatroskaNode::PrevUID.id: {
					information.previousUid = element.readHex
				}
				case MatroskaNode::NextUID.id: {
					information.nextUid = element.readHex
				}
			}

			element.skip
		}
	}

	def private void parseTracks(EbmlElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::TrackEntry.id: {
					val track = VilimaFactory.eINSTANCE.createMkTrack
					element.fill(track)
					result.tracks += track
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkTrack track) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::TrackNumber.id: {
					track.number = element.readInt
				}
				case MatroskaNode::TrackUID.id: {
					track.uid = element.readLong
				}
				case MatroskaNode::TrackType.id: {
					track.type = element.readMkTrackType
				}
				case MatroskaNode::Name.id: {
					track.name = element.readString
				}
				case MatroskaNode::Language.id: {
					track.language = element.readString
				}
				case MatroskaNode::CodecID.id: {
					track.codecId = element.readString
				}
				case MatroskaNode::CodecPrivate.id: {
					track.codecPrivate = element.extBinaryToString
				}
				case MatroskaNode::Video.id: {
					element.fillVideo(track)
				}
				case MatroskaNode::Audio.id: {
					element.fillAudio(track)
				}
			}

			element.skip
		}

		// XXX: rewrite
		MatroskaReader::rewriteCodecPrivate(track);
	}

	def private void fillVideo(EbmlElement parent, MkTrack track) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::PixelWidth.id: {
					track.videoPixelWidth = element.readInt
				}
				case MatroskaNode::PixelHeight.id: {
					track.videoPixelHeight = element.readInt
				}
				case MatroskaNode::DisplayWidth.id: {
					track.videoDisplayWidth = element.readInt
				}
				case MatroskaNode::DisplayHeight.id: {
					track.videoDisplayHeight = element.readInt
				}
			}

			element.skip
		}
	}

	def private void fillAudio(EbmlElement parent, MkTrack track) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::SamplingFrequency.id: {
					track.audioSamplingFrequency = element.readDouble
				}
				case MatroskaNode::Channels.id: {
					track.audioChannels = element.readShort
				}
			}

			element.skip
		}
	}

	def private void parseAttachments(EbmlElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::AttachedFile.id: {
					val attachment = VilimaFactory::eINSTANCE.createMkAttachment
					element.fill(attachment)

					result.attachments += attachment
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkAttachment attachment) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::FileDescription.id: {
					attachment.description = element.readString
				}
				case MatroskaNode::FileName.id: {
					attachment.name = element.readString
				}
				case MatroskaNode::FileMimeType.id: {
					attachment.mimeType = element.readString
				}
				case MatroskaNode::FileDescription.id: {
					attachment.size = element.size
				}
			}

			element.skip
		}
	}

	def private void parseChapters(EbmlMasterElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::EditionEntry.id: {
					val edition = VilimaFactory::eINSTANCE.createMkEdition()
					element.fill(edition)

					result.editions += edition
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkEdition edition) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::EditionUID.id: {
					edition.uid = element.readLong
				}
				case MatroskaNode::ChapterAtom.id: {
					val chapter = VilimaFactory::eINSTANCE.createMkChapter

					element.fill(chapter)

					edition.chapters += chapter
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkChapter chapter) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::ChapterTimeStart.id: {
					chapter.start = element.readLong
				}
				case MatroskaNode::ChapterDisplay.id: {
					val text = VilimaFactory.eINSTANCE.createMkChapterText()

					element.fill(text)

					chapter.texts += text
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkChapterText text) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::ChapString.id: {
					text.text = element.readString
				}
				case MatroskaNode::ChapLanguage.id: {
					text.languages += element.readString
				}
				case MatroskaNode::ChapCountry.id: {
					// TODO: ChapCountry not used
				}
			}

			element.skip
		}
	}

	def private void parseTags(EbmlElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::Tag.id: {
					val tag = VilimaFactory::eINSTANCE.createMkTag

					element.fill(tag)

					result.tags += tag
				}
			}

			element.skip
		}
	}

	def private fill(EbmlElement parent, MkTag tag) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::Targets.id: {
					element.parseTagTargets(tag)
				}
				case MatroskaNode::SimpleTag.id: {
					val node = VilimaFactory::eINSTANCE.createMkTagNode

					element.fill(node)

					tag.nodes += node
				}
			}

			element.skip
		}
	}

	def private void parseTagTargets(EbmlElement parent, MkTag tag) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element. id {
				case MatroskaNode::TargetTypeValue.id: {
					tag.target = element.readInt
				}
				case MatroskaNode::TargetType.id: {
					tag.targetText = element.readString
				}
				case MatroskaNode::TagTrackUID.id: {
					println("added non-global tag")
				}
				case MatroskaNode::TagEditionUID.id: {
					println("added non-global tag")
				}
				case MatroskaNode::TagChapterUID.id: {
					println("added non-global tag")
				}
				case MatroskaNode::TagAttachmentUID.id: {
					println("added non-global tag")
				}
			}

			element.skip
		}
	}

	def private void fill(EbmlElement parent, MkTagNode node) {
		while (parent.hasNext) {
			val element = parent.nextChild
			switch element.id {
				case MatroskaNode::TagName.id: {
					node.name = element.readString
				}
				case MatroskaNode::TagString.id: {
					node.value = element.readString
				}
				case MatroskaNode::SimpleTag.id: {
					val child = VilimaFactory::eINSTANCE.createMkTagNode

					element.fill(child)

					node.nodes += child
				}
			}

			element.skip
		}
	}

	def private long offset(EbmlMasterElement element) {
		return seeker.position - element.headerSize
	}

	def private void skip(EbmlElement element) {
		seeker.skip(element)
	}

	def private byte[] readBytes(EbmlElement element) {
		seeker.readBytes(element as EbmlDataElement)
	}

	def private long readLong(EbmlElement element) {
		seeker.readInteger(element as EbmlDataElement)
	}

	def private double readDouble(EbmlElement element) {
		seeker.readDouble(element as EbmlDataElement)
	}

	def private String readString(EbmlElement element) {
		seeker.readString(element as EbmlDataElement)
	}

	def private short readShort(EbmlElement element) {
		seeker.readInteger(element as EbmlDataElement) as short
	}

	def private EbmlElement nextChild(EbmlElement element) {
		return seeker.nextChild(element as EbmlMasterElement)
	}

	def private String extBinaryToString(EbmlElement element) {
		val byte[] value = seeker.readBytes(element as EbmlDataElement);

		return MatroskaReader::convertBinaryToString(value)
	}

	def private int readInt(EbmlElement element) {
		seeker.readInteger(element as EbmlDataElement) as int
	}

	def private String readHex(EbmlElement element) {
		MkReaderByter::bytesToHex(element.readBytes)
	}

	def private MkTrackType readMkTrackType(EbmlElement element) {
		MkReaderByter::convertTrackType(element.readLong as byte)
	}

	def private boolean hasNext(EbmlElement element) {
		if (element instanceof EbmlMasterElement) {
			return element.hasNext
		}

		return false
	}
}

class ReaderHelper {
	def MkFile createMkFile(File file) {
		val result = VilimaFactory::eINSTANCE.createMkFile()

		result.name = file.name
		result.path = file.parent
		result.dateModified = file.lastModified
		result.size = file.length

		return result
	}
}
