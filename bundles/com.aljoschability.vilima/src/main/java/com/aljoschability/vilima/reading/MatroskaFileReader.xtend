package com.aljoschability.vilima.reading

import java.io.File
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.VilimaFactory
import java.util.Collection
import com.aljoschability.vilima.MkInformation
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkChapterText
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagEntry
import com.aljoschability.vilima.MkTrackType

class MatroskaFileReader {
	extension ReaderHelper helper = new ReaderHelper

	MkFile result
	MatroskaFileSeeker seeker

	Collection<Long> seeks
	Collection<Long> positions
	long seekOffset

	def MkFile readFile(File file) {
		init(file)

		readFile()

		readSeeks()

		dispose()

		return result
	}

	def private void init(File file) {
		result = file.createMkFile

		seeks = newArrayList
		positions = newArrayList
		seekOffset = -1

		seeker = new MatroskaFileSeeker(file.toPath)
	}

	def private void dispose() {
		seeker.dispose()

		seeks = null
		positions = null
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
					val value = element.extString

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
		positions += element.offset

		switch element.id {
			case MatroskaNode::SeekHead.id: {
				element.readSeekHead
			}
			case MatroskaNode::Info.id: {
				if (result.information != null) {
					throw new RuntimeException("Info already exists.")
				}

				result.information = element.createInformation
			}
			case MatroskaNode::Cluster.id: {
				return false
			}
			case MatroskaNode::Tracks.id: {
				element.readTracks
			}
			case MatroskaNode::Attachments.id: {
				element.readAttachments
			}
			case MatroskaNode::Chapters.id: {
				element.readChapters
			}
			case MatroskaNode::Tags.id: {
				element.readTags
			}
		}

		return true
	}

	def private void readSeekHead(EbmlMasterElement parent) {
		var EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::Seek.matches(element)) {
				readSeek(element as EbmlMasterElement);
			}

			element.skip
		}
	}

	def private byte[] extBytes(EbmlElement element) {
		seeker.readBytes(element as EbmlDataElement)
	}

	def private String readHex(EbmlElement element) {
		MatroskaReader::bytesToHex(element.extBytes)
	}

	def private double readDouble(EbmlElement element) {
		seeker.readDouble(element as EbmlDataElement)
	}

	def private long extLong(EbmlElement element) {
		seeker.readLong(element as EbmlDataElement)
	}

	def private MkTrackType readTrackType(EbmlElement element) {
		val byte value = seeker.readLong(element as EbmlDataElement) as byte;

		return MatroskaReader::convertTrackType(value)
	}

	def private String extBinaryToString(EbmlElement element) {
		val byte[] value = seeker.readBytes(element as EbmlDataElement);

		return MatroskaReader::convertBinaryToString(value)
	}

	def private String extString(EbmlElement element) {
		seeker.readString(element as EbmlDataElement)
	}

	def private int extInt(EbmlElement element) {
		seeker.readLong(element as EbmlDataElement) as int
	}

	def private void readSeek(EbmlMasterElement parent) {
		var byte[] id = null;
		var long position = -1;

		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			switch element.id {
				case MatroskaNode::SeekID.id: {
					id = element.extBytes
				}
				case MatroskaNode::SeekPosition.id: {
					position = element.extLong
				}
			}

			element.skip
		}

		// ignore cluster
		val MatroskaNode node = MatroskaNode::get(id)
		if (!MatroskaNode::Cluster.equals(node)) {
			seeks += (position + seekOffset)
		}
	}

	def private MkInformation createInformation(EbmlElement parent) {
		val result = VilimaFactory.eINSTANCE.createMkInformation

		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::Title.id: {
					result.title = element.extString
				}
				case MatroskaNode::SegmentUID.id: {
					result.uid = element.readHex
				}
				case MatroskaNode::DateUTC.id: {

					// XXX: this should use the "international format"...
					result.date = seeker.readTimestamp(element as EbmlDataElement)
				}
				case MatroskaNode::MuxingApp.id: {
					result.muxingApp = element.extString
				}
				case MatroskaNode::WritingApp.id: {
					result.writingApp = element.extString
				}
				case MatroskaNode::Duration.id: {
					result.duration = element.readDouble
				}
				case MatroskaNode::PrevUID.id: {
					result.previousUid = element.readHex
				}
				case MatroskaNode::NextUID.id: {
					result.nextUid = element.readHex
				}
			}

			element.skip
		}

		return result
	}

	def private void readTracks(EbmlElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::TrackEntry.id: {
					element.readTrackEntry
				}
			}

			element.skip
		}
	}

	def private void readTrackEntry(EbmlElement parent) {
		val entry = VilimaFactory.eINSTANCE.createMkTrack

		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::TrackNumber.id: {
					entry.number = element.extInt
				}
				case MatroskaNode::TrackUID.id: {
					entry.uid = element.extLong
				}
				case MatroskaNode::TrackType.id: {
					entry.type = element.readTrackType
				}
				case MatroskaNode::Name.id: {
					entry.name = element.extString
				}
				case MatroskaNode::Language.id: {
					entry.language = element.extString
				}
				case MatroskaNode::CodecID.id: {
					entry.codecId = element.extString
				}
				case MatroskaNode::CodecPrivate.id: {
					entry.codecPrivate = element.extBinaryToString
				}
				case MatroskaNode::Video.id: {
					readTrackVideoDetails(element as EbmlMasterElement, entry);
				}
				case MatroskaNode::Audio.id: {
					readTrackAudioDetails(element as EbmlMasterElement, entry);
				}
			}

			element.skip
		}

		MatroskaReader::rewriteCodecPrivate(entry);

		result.getTracks().add(entry);
	}

	def private void readTrackAudioDetails(EbmlMasterElement parent, MkTrack track) {
		var EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::SamplingFrequency.matches(element)) {
				var double value = seeker.readDouble(element as EbmlDataElement);

				track.setAudioSamplingFrequency(value);
			} else if (MatroskaNode::Channels.matches(element)) {
				var value = seeker.readLong(element as EbmlDataElement);

				track.setAudioChannels(value as short);
			}

			element.skip
		}
	}

	def private EbmlElement nextChild(EbmlElement element) {
		return seeker.nextChild(element as EbmlMasterElement)
	}

	def private void readTrackVideoDetails(EbmlMasterElement parent, MkTrack track) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::PixelWidth.id: {
					track.videoPixelWidth = element.extInt
				}
				case MatroskaNode::PixelHeight.id: {
					track.videoPixelHeight = element.extInt
				}
				case MatroskaNode::DisplayWidth.id: {
					track.videoDisplayWidth = element.extInt
				}
				case MatroskaNode::DisplayHeight.id: {
					track.videoDisplayHeight = element.extInt
				}
			}

			element.skip
		}
	}

	def private void readAttachments(EbmlMasterElement parent) {
		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::AttachedFile.id: {
					result.attachments += (element as EbmlMasterElement).parseAttachedFile
				}
			}

			element.skip
		}
	}

	def private boolean hasNext(EbmlElement element) {
		if (element instanceof EbmlMasterElement) {
			return element.hasNext
		}

		return false
	}

	def private MkAttachment parseAttachedFile(EbmlElement parent) {
		val attachment = VilimaFactory.eINSTANCE.createMkAttachment()

		while (parent.hasNext) {
			val element = parent.nextChild

			switch element.id {
				case MatroskaNode::FileDescription.id: {
					attachment.description = element.extString
				}
				case MatroskaNode::FileName.id: {
					attachment.name = element.extString
				}
				case MatroskaNode::FileMimeType.id: {
					attachment.mimeType = element.extString
				}
				case MatroskaNode::FileDescription.id: {
					attachment.size = element.size
				}
			}

			element.skip
		}

		return attachment
	}

	def private void readChapters(EbmlMasterElement parent) {
		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::EditionEntry.matches(element)) {
				var MkEdition chapter = VilimaFactory.eINSTANCE.createMkEdition();

				readEditionEntry(element as EbmlMasterElement, chapter);

				result.getEditions().add(chapter);
			}

			element.skip
		}
	}

	def private void readEditionEntry(EbmlMasterElement parent, MkEdition chapter) {
		var EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::EditionUID.matches(element)) {
				chapter.setUid(seeker.readLong(element as EbmlDataElement));
			} else if (MatroskaNode::ChapterAtom.matches(element)) {
				var MkChapter entry = VilimaFactory.eINSTANCE.createMkChapter();

				readChapterAtom(element as EbmlMasterElement, entry);

				chapter.getChapters().add(entry);
			}

			element.skip
		}
	}

	def private void readChapterAtom(EbmlMasterElement parent, MkChapter entry) {
		var EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::ChapterTimeStart.matches(element)) {
				entry.setStart(seeker.readLong(element as EbmlDataElement));
			} else if (MatroskaNode::ChapterDisplay.matches(element)) {
				var MkChapterText display = VilimaFactory.eINSTANCE.createMkChapterText();

				readChapterDisplay(element as EbmlMasterElement, display);

				entry.getTexts().add(display);
			}

			element.skip
		}
	}

	def private void readChapterDisplay(EbmlMasterElement parent, MkChapterText display) {
		var EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::ChapString.matches(element)) {
				display.setText(seeker.readString(element as EbmlDataElement));
			} else if (MatroskaNode::ChapLanguage.matches(element)) {
				display.getLanguages().add(seeker.readString(element as EbmlDataElement));
			} else if (MatroskaNode::ChapCountry.matches(element)) {
				// TODO: ChapCountry not used
			}

			element.skip
		}
	}

	def private void readTags(EbmlMasterElement parent) {
		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::Tag.matches(element)) {
				var MkTag tag = VilimaFactory.eINSTANCE.createMkTag();

				// only add when tags are global (not track-specific)
				if (readTag(element as EbmlMasterElement, tag)) {
					result.getTags().add(tag);
				}
			}

			element.skip
		}
	}

	def private boolean readTag(EbmlMasterElement parent, MkTag tag) {
		var boolean global = true;

		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::Targets.matches(element)) {
				global = readTagTargets(element as EbmlMasterElement, tag);
			} else if (MatroskaNode::SimpleTag.matches(element)) {
				var MkTagEntry entry = readTagsSimpleTag(element as EbmlMasterElement);
				if (entry != null) {
					tag.getEntries().add(entry);
				}
			}

			element.skip
		}

		return global;
	}

	def private boolean readTagTargets(EbmlMasterElement parent, MkTag tag) {
		var boolean global = true;

		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::TargetTypeValue.matches(element)) {
				tag.setTarget(seeker.readLong(element as EbmlDataElement) as int);
			} else if (MatroskaNode::TargetType.matches(element)) {
				tag.setTargetText(seeker.readString(element as EbmlDataElement));
			} else if (MatroskaNode::TagTrackUID.matches(element)) {
				global = false;
			} else if (MatroskaNode::TagEditionUID.matches(element)) {
				global = false;
			} else if (MatroskaNode::TagChapterUID.matches(element)) {
				global = false;
			} else if (MatroskaNode::TagAttachmentUID.matches(element)) {
				global = false;
			}

			element.skip
		}

		return global;
	}

	def private MkTagEntry readTagsSimpleTag(EbmlMasterElement parent) {
		var MkTagEntry tag = VilimaFactory.eINSTANCE.createMkTagEntry();

		var EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode::TagName.matches(element)) {
				tag.setName(seeker.readString(element as EbmlDataElement));
			} else if (MatroskaNode::TagString.matches(element)) {
				tag.setValue(seeker.readString(element as EbmlDataElement));
			} else if (MatroskaNode::SimpleTag.matches(element)) {
				tag.getEntries().add(readTagsSimpleTag(element as EbmlMasterElement));
			}

			element.skip
		}

		return tag;
	}

	def private void readSeeks() {

		// remove already read elements
		for (Long position : positions) {
			seeks.remove(position)
		}

		// read the referenced elements
		for (Long position : seeks) {
			val element = seeker.nextElement(position)
			readSegmentNode(element as EbmlMasterElement)
		}
	}

	def private void skip(EbmlElement element) {
		seeker.skip(element)
	}

	def private long offset(EbmlMasterElement element) {
		return seeker.position - element.headerSize
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
