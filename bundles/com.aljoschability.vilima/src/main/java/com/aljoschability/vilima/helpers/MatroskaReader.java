package com.aljoschability.vilima.helpers;

import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import com.aljoschability.vilima.MkAttachment;
import com.aljoschability.vilima.MkChapter;
import com.aljoschability.vilima.MkChapterText;
import com.aljoschability.vilima.MkEdition;
import com.aljoschability.vilima.MkFile;
import com.aljoschability.vilima.MkInformation;
import com.aljoschability.vilima.MkTag;
import com.aljoschability.vilima.MkTagNode;
import com.aljoschability.vilima.MkTrack;
import com.aljoschability.vilima.XVilimaContentType;
import com.aljoschability.vilima.VilimaFactory;
import com.aljoschability.vilima.XVilimaGenre;
import com.aljoschability.vilima.XVilimaLibrary;
import com.aljoschability.vilima.reading.EbmlDataElement;
import com.aljoschability.vilima.reading.EbmlElement;
import com.aljoschability.vilima.reading.EbmlMasterElement;
import com.aljoschability.vilima.reading.MatroskaFileSeeker;
import com.aljoschability.vilima.reading.MatroskaNode;

public class MatroskaReader {

	private final XVilimaLibrary library;

	private MkFile file;
	private MatroskaFileSeeker seeker;

	private Collection<Long> seeks;
	private Collection<Long> positions;
	private long seekOffset;

	@Deprecated
	public MatroskaReader(XVilimaLibrary library) {
		this.library = library;
	}

	public MkFile readFile(Path path) throws IOException {
		file = VilimaFactory.eINSTANCE.createMkFile();
		file.setName(path.getFileName().toString());
		file.setPath(path.getParent().toString());
		file.setDateModified(path.toFile().lastModified());
		file.setSize(path.toFile().length());

		// reset
		seeks = new ArrayList<>();
		positions = new ArrayList<>();
		seekOffset = -1;

		seeker = new MatroskaFileSeeker(path);

		// parse the file
		readFile();

		// remove already read elements
		for (Long position : positions) {
			seeks.remove(position);
		}

		// read the referenced elements
		for (Long position : seeks) {
			EbmlElement element = seeker.nextElement(position);
			readSegmentNode((EbmlMasterElement) element);
		}

		// close file seeker
		seeker.dispose();

		return file;
	}

	private void readFile() throws IOException {
		EbmlElement element = seeker.nextElement();
		if (!MatroskaNode.EBML.matches(element)) {
			throw new RuntimeException("EBML root element could not be read.");
		}

		readDocType((EbmlMasterElement) element);

		element = seeker.nextElement();
		if (!MatroskaNode.Segment.matches(element)) {
			throw new RuntimeException(
					"Segment not the second element in the file.");
		}

		readSegment((EbmlMasterElement) element);
	}

	private void readDocType(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.DocType.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				if (!(value.equals("matroska") || value.equals("webm"))) {
					throw new RuntimeException(
							"EBML document type cannot be read.");
				}
			}

			seeker.skip(element);
		}
	}

	private void readSegment(EbmlMasterElement parent) throws IOException {
		seekOffset = seeker.getPosition();

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (element instanceof EbmlMasterElement) {
				if (!readSegmentNode((EbmlMasterElement) element)) {
					return;
				}
			}

			seeker.skip(element);
		}
	}

	private boolean readSegmentNode(EbmlMasterElement element)
			throws IOException {
		positions.add(seeker.getPosition() - element.getHeaderSize());

		if (MatroskaNode.SeekHead.matches(element)) {
			readSeekHead(element);
		} else if (MatroskaNode.Info.matches(element)) {
			if (file.getInformation() != null) {
				throw new RuntimeException("Info already exists.");
			}
			file.setInformation(readInfo(element));
		} else if (MatroskaNode.Cluster.matches(element)) {
			return false;
		} else if (MatroskaNode.Tracks.matches(element)) {
			readTracks(element);
		} else if (MatroskaNode.Attachments.matches(element)) {
			readAttachments(element);
		} else if (MatroskaNode.Chapters.matches(element)) {
			readChapters(element);
		} else if (MatroskaNode.Tags.matches(element)) {
			readTags(element);
		}

		return true;
	}

	private void readSeekHead(EbmlMasterElement parent) throws IOException {
		EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Seek.matches(element)) {
				readSeek((EbmlMasterElement) element);
			}

			seeker.skip(element);
		}
	}

	private void readSeek(EbmlMasterElement parent) throws IOException {
		byte[] id = null;
		long position = -1;

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.SeekID.matches(element)) {
				id = seeker.readBytes((EbmlDataElement) element);
			} else if (MatroskaNode.SeekPosition.matches(element)) {
				position = seeker.readInteger((EbmlDataElement) element);
			}

			seeker.skip(element);
		}

		// ignore cluster
		MatroskaNode node = MatroskaNode.get(id);
		if (!MatroskaNode.Cluster.equals(node)) {
			seeks.add(position + seekOffset);
		}
	}

	private MkInformation readInfo(EbmlMasterElement parent) throws IOException {
		MkInformation segment = VilimaFactory.eINSTANCE.createMkInformation();

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Title.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				segment.setTitle(value);
			} else if (MatroskaNode.SegmentUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				segment.setUid(MkReaderByter.bytesToHex(value));
			} else if (MatroskaNode.DateUTC.matches(element)) {
				long value = seeker.readTimestamp((EbmlDataElement) element);

				segment.setDate(value);
			} else if (MatroskaNode.MuxingApp.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				segment.setMuxingApp(value);
			} else if (MatroskaNode.WritingApp.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				segment.setWritingApp(value);
			} else if (MatroskaNode.Duration.matches(element)) {
				double value = seeker.readDouble((EbmlDataElement) element);

				segment.setDuration(value);
			} else if (MatroskaNode.PrevUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				segment.setPreviousUid(MkReaderByter.bytesToHex(value));
			} else if (MatroskaNode.NextUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				segment.setNextUid(MkReaderByter.bytesToHex(value));
			}

			seeker.skip(element);
		}

		return segment;
	}

	private void readTracks(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TrackEntry.matches(element)) {
				readTrackEntry((EbmlMasterElement) element);
			}

			seeker.skip(element);
		}
	}

	private void readTrackEntry(EbmlMasterElement parent) throws IOException {
		MkTrack track = VilimaFactory.eINSTANCE.createMkTrack();

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TrackNumber.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setNumber(value);
			} else if (MatroskaNode.TrackUID.matches(element)) {
				long value = seeker.readInteger((EbmlDataElement) element);

				track.setUid(value);
			} else if (MatroskaNode.TrackType.matches(element)) {
				byte value = (byte) seeker
						.readInteger((EbmlDataElement) element);

				track.setType(MkReaderByter.convertTrackType(value));
			} else if (MatroskaNode.Name.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				track.setName(value);
			} else if (MatroskaNode.Language.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				track.setLanguage(value);
			} else if (MatroskaNode.CodecID.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				track.setCodecId(value);
			} else if (MatroskaNode.CodecPrivate.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				track.setCodecPrivate(convertBinaryToString(value));
			} else if (MatroskaNode.Video.matches(element)) {
				readTrackVideoDetails((EbmlMasterElement) element, track);
			} else if (MatroskaNode.Audio.matches(element)) {
				readTrackAudioDetails((EbmlMasterElement) element, track);
			}

			seeker.skip(element);
		}

		rewriteCodecPrivate(track);

		file.getTracks().add(track);
	}

	private void readTrackAudioDetails(EbmlMasterElement parent, MkTrack track)
			throws IOException {
		EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.SamplingFrequency.matches(element)) {
				double value = seeker.readDouble((EbmlDataElement) element);

				track.setAudioSamplingFrequency(value);
			} else if (MatroskaNode.Channels.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setAudioChannels(value);
			}

			seeker.skip(element);
		}
	}

	private void readTrackVideoDetails(EbmlMasterElement parent, MkTrack track)
			throws IOException {
		EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.PixelWidth.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setVideoPixelWidth(value);
			} else if (MatroskaNode.PixelHeight.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setVideoPixelHeight(value);
			} else if (MatroskaNode.DisplayWidth.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setVideoDisplayWidth(value);
			} else if (MatroskaNode.DisplayHeight.matches(element)) {
				int value = (int) seeker.readInteger((EbmlDataElement) element);

				track.setVideoDisplayHeight(value);
			}

			seeker.skip(element);
		}
	}

	private void readAttachments(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.AttachedFile.matches(element)) {
				MkAttachment attachment = VilimaFactory.eINSTANCE
						.createMkAttachment();

				readAttachedFile((EbmlMasterElement) element, attachment);

				file.getAttachments().add(attachment);
			}

			seeker.skip(element);
		}
	}

	private void readAttachedFile(EbmlMasterElement parent,
			MkAttachment attachment) throws IOException {
		EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.FileDescription.matches(element)) {
				attachment.setDescription(seeker
						.readString((EbmlDataElement) element));
			} else if (MatroskaNode.FileName.matches(element)) {
				attachment
						.setName(seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.FileMimeType.matches(element)) {
				attachment.setMimeType(seeker
						.readString((EbmlDataElement) element));
			} else if (MatroskaNode.FileData.matches(element)) {
				attachment.setSize(element.getSize());
			}

			seeker.skip(element);
		}
	}

	private void readChapters(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.EditionEntry.matches(element)) {
				MkEdition chapter = VilimaFactory.eINSTANCE.createMkEdition();

				readEditionEntry((EbmlMasterElement) element, chapter);

				file.getEditions().add(chapter);
			}

			seeker.skip(element);
		}
	}

	private void readEditionEntry(EbmlMasterElement parent, MkEdition chapter)
			throws IOException {
		EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.EditionUID.matches(element)) {
				chapter.setUid(seeker.readInteger((EbmlDataElement) element));
			} else if (MatroskaNode.ChapterAtom.matches(element)) {
				MkChapter entry = VilimaFactory.eINSTANCE.createMkChapter();

				readChapterAtom((EbmlMasterElement) element, entry);

				chapter.getChapters().add(entry);
			}

			seeker.skip(element);
		}
	}

	private void readChapterAtom(EbmlMasterElement parent, MkChapter entry)
			throws IOException {
		EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.ChapterTimeStart.matches(element)) {
				entry.setStart(seeker.readInteger((EbmlDataElement) element));
			} else if (MatroskaNode.ChapterDisplay.matches(element)) {
				MkChapterText display = VilimaFactory.eINSTANCE
						.createMkChapterText();

				readChapterDisplay((EbmlMasterElement) element, display);

				entry.getTexts().add(display);
			}

			seeker.skip(element);
		}
	}

	private void readChapterDisplay(EbmlMasterElement parent,
			MkChapterText display) throws IOException {
		EbmlElement element;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.ChapString.matches(element)) {
				display.setText(seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.ChapLanguage.matches(element)) {
				display.getLanguages().add(
						seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.ChapCountry.matches(element)) {
				// TODO: ChapCountry not used
			}

			seeker.skip(element);
		}
	}

	private void readTags(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Tag.matches(element)) {
				MkTag tag = VilimaFactory.eINSTANCE.createMkTag();

				// only add when tags are global (not track-specific)
				if (readTag((EbmlMasterElement) element, tag)) {
					file.getTags().add(tag);
				}
			}

			seeker.skip(element);
		}
	}

	private boolean readTag(EbmlMasterElement parent, MkTag tag)
			throws IOException {
		boolean global = true;

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Targets.matches(element)) {
				global = readTagTargets((EbmlMasterElement) element, tag);
			} else if (MatroskaNode.SimpleTag.matches(element)) {
				MkTagNode entry = readTagsSimpleTag((EbmlMasterElement) element);
				if (entry != null) {
					tag.getNodes().add(entry);
				}
			}

			seeker.skip(element);
		}

		return global;
	}

	private boolean readTagTargets(EbmlMasterElement parent, MkTag tag)
			throws IOException {
		boolean global = true;

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TargetTypeValue.matches(element)) {
				tag.setTarget((int) seeker
						.readInteger((EbmlDataElement) element));
			} else if (MatroskaNode.TargetType.matches(element)) {
				tag.setTargetText(seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.TagTrackUID.matches(element)) {
				global = false;
			} else if (MatroskaNode.TagEditionUID.matches(element)) {
				global = false;
			} else if (MatroskaNode.TagChapterUID.matches(element)) {
				global = false;
			} else if (MatroskaNode.TagAttachmentUID.matches(element)) {
				global = false;
			}

			seeker.skip(element);
		}

		return global;
	}

	private MkTagNode readTagsSimpleTag(EbmlMasterElement parent)
			throws IOException {
		MkTagNode tag = VilimaFactory.eINSTANCE.createMkTagNode();

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TagName.matches(element)) {
				tag.setName(seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.TagString.matches(element)) {
				tag.setValue(seeker.readString((EbmlDataElement) element));
			} else if (MatroskaNode.SimpleTag.matches(element)) {
				tag.getNodes().add(
						readTagsSimpleTag((EbmlMasterElement) element));
			}

			seeker.skip(element);
		}

		if ("CONTENT_TYPE".equals(tag.getName())) {
			// file.setContentType(getOrCreateContentType(tag.getValue()));
			// return null;
		}
		if ("GENRE".equals(tag.getName())) {
			// file.getGenres().add(getOrCreateGenre(tag.getValue()));
			// return null;
		}

		return tag;
	}

	private XVilimaContentType getOrCreateContentType(String value) {
		for (XVilimaContentType existing : library.getContentTypes()) {
			if (existing.getName().equals(value)) {
				return existing;
			}
		}

		XVilimaContentType type = VilimaFactory.eINSTANCE
				.createXVilimaContentType();
		type.setName(value);
		library.getContentTypes().add(type);

		return type;
	}

	private XVilimaGenre getOrCreateGenre(String value) {
		for (XVilimaGenre existing : library.getGenres()) {
			if (existing.getName().equals(value)) {
				return existing;
			}
		}

		XVilimaGenre type = VilimaFactory.eINSTANCE.createXVilimaGenre();
		type.setName(value);
		library.getGenres().add(type);

		return type;
	}

	public static void rewriteCodecPrivate(MkTrack track) {
		if (track.getCodecPrivate() != null) {
			// reconstruct byte array
			String[] split = track.getCodecPrivate()
					.substring(1, track.getCodecPrivate().length() - 2)
					.split(", ");
			byte[] bytes = new byte[split.length];
			for (int i = 0; i < bytes.length; i++) {
				bytes[i] = new Byte(split[i]);
			}

			if ("V_MPEG4/ISO/AVC".equals(track.getCodecId())) {
				track.setCodecPrivate("Profile=" + bytes[1] + ", Level="
						+ bytes[3]);
			} else if ("V_MS/VFW/FOURCC".equals(track.getCodecId())) {
				// System.out.println(Arrays.toString(new byte[] { 'X', 'V',
				// 'I', 'D' }));
				track.setCodecPrivate(new String(new byte[] { bytes[16],
						bytes[17], bytes[18], bytes[19] }));
				// [40, 0, 0, 0, -48, 2, 0, 0, 96, 1, 0, 0, 1, 0, 12, 0, 88, 86,
				// 73, 68, 0, 52, 23,
				// 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

			}
		}
	}

	public static String convertBinaryToString(byte[] value) {
		return Arrays.toString(value);
	}
}
