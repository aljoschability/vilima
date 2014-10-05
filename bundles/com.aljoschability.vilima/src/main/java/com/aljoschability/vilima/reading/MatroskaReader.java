package com.aljoschability.vilima.reading;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

import com.aljoschability.vilima.MkvAttachment;
import com.aljoschability.vilima.MkvChapter;
import com.aljoschability.vilima.MkvFile;
import com.aljoschability.vilima.MkvTag;
import com.aljoschability.vilima.MkvTagEntry;
import com.aljoschability.vilima.MkvTrack;
import com.aljoschability.vilima.MkvTrackType;
import com.aljoschability.vilima.VilimaFactory;

public class MatroskaReader {
	private static char[] HEX = "0123456789ABCDEF".toCharArray();

	private MkvFile file;
	private MatroskaFileSeeker seeker;

	private Map<Long, String> elements;
	private Map<Long, MatroskaNode> seeks;
	private long seekOffset;

	public void readFile(MkvFile file) throws IOException {
		this.file = file;

		// reset
		elements = new LinkedHashMap<>();
		seeks = new LinkedHashMap<>();
		seekOffset = -1;

		seeker = new MatroskaFileSeeker(Paths.get(file.getFilePath(), file.getFileName()));

		// parse the file
		readFile();

		// remove already read elements
		for (Long position : elements.keySet()) {
			seeks.remove(position);
		}

		// read the referenced elements
		for (Long position : seeks.keySet()) {
			EbmlElement element = seeker.nextElement(position);
			readSegmentNode((EbmlMasterElement) element);
		}

		// close file seeker
		seeker.dispose();
	}

	private void readFile() throws IOException {
		EbmlElement element = seeker.nextElement();
		if (!MatroskaNode.EBML.matches(element)) {
			throw new RuntimeException("EBML root element could not be read.");
		}

		readDocType((EbmlMasterElement) element);

		element = seeker.nextElement();
		if (!MatroskaNode.Segment.matches(element)) {
			throw new RuntimeException("Segment not the second element in the file.");
		}

		readSegment((EbmlMasterElement) element);
	}

	private void readDocType(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.DocType.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				if (!(value.equals("matroska") || value.equals("webm"))) {
					throw new RuntimeException("EBML document type cannot be read.");
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

	private boolean readSegmentNode(EbmlMasterElement element) throws IOException {
		if (MatroskaNode.SeekHead.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "SeekHead");
			readSeekHead(element);
		} else if (MatroskaNode.Info.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "Info");
			readInfo(element);
		} else if (MatroskaNode.Cluster.matches(element)) {
			return false;
		} else if (MatroskaNode.Tracks.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "Tracks");
			readTracks(element);
		} else if (MatroskaNode.Attachments.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "Attachments");
			readAttachments(element);
		} else if (MatroskaNode.Chapters.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "Chapters");
			readChapters(element);
		} else if (MatroskaNode.Tags.matches(element)) {
			elements.put(seeker.getPosition() - element.getHeaderSize(), "Tags");
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
				position = seeker.readLong((EbmlDataElement) element);
			}

			seeker.skip(element);
		}

		// ignore cluster
		MatroskaNode node = MatroskaNode.get(id);
		if (!MatroskaNode.Cluster.equals(node)) {
			seeks.put(position + seekOffset, node);
		}
	}

	private void readInfo(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Title.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				file.setSegmentTitle(value);
			} else if (MatroskaNode.SegmentUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				file.setSegmentUid(bytesToHex(value));
			} else if (MatroskaNode.DateUTC.matches(element)) {
				long value = seeker.readTimestamp((EbmlDataElement) element);

				file.setSegmentDate(value);
			} else if (MatroskaNode.MuxingApp.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				file.setSegmentMuxingApp(value);
			} else if (MatroskaNode.WritingApp.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				file.setSegmentWritingApp(value);
			} else if (MatroskaNode.Duration.matches(element)) {
				double value = seeker.readDouble((EbmlDataElement) element);

				file.setSegmentDuration((long) value);
			} else if (MatroskaNode.TimecodeScale.matches(element)) {
				long value = seeker.readLong((EbmlDataElement) element);

				file.setSegmentTimecodeScale(value);
			} else if (MatroskaNode.PrevUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				file.setSegmentPreviousUid(bytesToHex(value));
			} else if (MatroskaNode.NextUID.matches(element)) {
				byte[] value = seeker.readBytes((EbmlDataElement) element);

				file.setSegmentNextUid(bytesToHex(value));
			}

			seeker.skip(element);
		}
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
		MkvTrack track = VilimaFactory.eINSTANCE.createMkvTrack();

		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TrackNumber.matches(element)) {
				int value = (int) seeker.readLong((EbmlDataElement) element);

				track.setNumber(value);
			} else if (MatroskaNode.TrackUID.matches(element)) {
				long value = seeker.readLong((EbmlDataElement) element);

				track.setUid(value);
			} else if (MatroskaNode.TrackType.matches(element)) {
				byte value = (byte) seeker.readLong((EbmlDataElement) element);

				track.setType(convertTrackType(value));
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

	private void readTrackAudioDetails(EbmlMasterElement parent, MkvTrack track) throws IOException {
		EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.SamplingFrequency.matches(element)) {
				double value = seeker.readDouble((EbmlDataElement) element);

				track.setAudioSamplingFrequency(value);
			} else if (MatroskaNode.Channels.matches(element)) {
				short value = (short) seeker.readLong((EbmlDataElement) element);

				track.setAudioChannels(value);
			}

			seeker.skip(element);
		}
	}

	private void readTrackVideoDetails(EbmlMasterElement parent, MkvTrack track) throws IOException {
		EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.PixelWidth.matches(element)) {
				short value = (short) seeker.readLong((EbmlDataElement) element);

				track.setVideoPixelWidth(value);
			} else if (MatroskaNode.PixelHeight.matches(element)) {
				short value = (short) seeker.readLong((EbmlDataElement) element);

				track.setVideoPixelHeight(value);
			} else if (MatroskaNode.DisplayWidth.matches(element)) {
				short value = (short) seeker.readLong((EbmlDataElement) element);

				track.setVideoDisplayWidth(value);
			} else if (MatroskaNode.DisplayHeight.matches(element)) {
				short value = (short) seeker.readLong((EbmlDataElement) element);

				track.setVideoDisplayHeight(value);
			}

			seeker.skip(element);
		}
	}

	private void readAttachments(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.AttachedFile.matches(element)) {
				// TODO: not implemented
				MkvAttachment a = VilimaFactory.eINSTANCE.createMkvAttachment();
				a.setName(Arrays.toString(element.getId()));
				file.getAttachments().add(a);
			}

			seeker.skip(element);
		}
	}

	private void readChapters(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.EditionEntry.matches(element)) {
				// TODO: not implemented
				MkvChapter a = VilimaFactory.eINSTANCE.createMkvChapter();
				a.setName(Arrays.toString(element.getId()));
				file.getChapters().add(a);
			}

			seeker.skip(element);
		}
	}

	private void readTags(EbmlMasterElement parent) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Tag.matches(element)) {
				MkvTag tag = VilimaFactory.eINSTANCE.createMkvTag();

				readTag((EbmlMasterElement) element, tag);

				file.getTags().add(tag);
			}

			seeker.skip(element);
		}
	}

	private void readTag(EbmlMasterElement parent, MkvTag tag) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.Targets.matches(element)) {
				readTagTargets((EbmlMasterElement) element, tag);
			} else if (MatroskaNode.SimpleTag.matches(element)) {
				tag.getEntries().add(readTagsSimpleTag((EbmlMasterElement) element));
			}

			seeker.skip(element);
		}
	}

	private void readTagTargets(EbmlMasterElement parent, MkvTag tag) throws IOException {
		EbmlElement element = null;
		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TagTrackUID.matches(element)) {
				long value = seeker.readLong((EbmlDataElement) element);

				tag.setTrackUid(value);
			} else if (MatroskaNode.TagChapterUID.matches(element)) {
				long value = seeker.readLong((EbmlDataElement) element);

				tag.setChapterUid(value);
			} else if (MatroskaNode.TagAttachmentUID.matches(element)) {
				long value = seeker.readLong((EbmlDataElement) element);

				tag.setAttachmentUid(value);
			}

			seeker.skip(element);
		}
	}

	private MkvTagEntry readTagsSimpleTag(EbmlMasterElement parent) throws IOException {
		MkvTagEntry tag = VilimaFactory.eINSTANCE.createMkvTagEntry();

		EbmlElement element = null;

		while ((element = seeker.nextChild(parent)) != null) {
			if (MatroskaNode.TagName.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				tag.setName(value);
			} else if (MatroskaNode.TagString.matches(element)) {
				String value = seeker.readString((EbmlDataElement) element);

				tag.setString(value);
			} else if (MatroskaNode.SimpleTag.matches(element)) {
				tag.getEntries().add(readTagsSimpleTag(parent));
			}

			seeker.skip(element);
		}

		return tag;
	}

	public static String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = HEX[v >>> 4];
			hexChars[j * 2 + 1] = HEX[v & 0x0F];
		}
		return new String(hexChars);
	}

	private static void rewriteCodecPrivate(MkvTrack track) {
		if (track.getCodecPrivate() != null) {
			// reconstruct byte array
			String[] split = track.getCodecPrivate().substring(1, track.getCodecPrivate().length() - 2).split(", ");
			byte[] bytes = new byte[split.length];
			for (int i = 0; i < bytes.length; i++) {
				bytes[i] = new Byte(split[i]);
			}

			if ("V_MPEG4/ISO/AVC".equals(track.getCodecId())) {
				track.setCodecPrivate("Profile=" + bytes[1] + ", Level=" + bytes[3]);
			} else if ("V_MS/VFW/FOURCC".equals(track.getCodecId())) {
				// System.out.println(Arrays.toString(new byte[] { 'X', 'V',
				// 'I', 'D' }));
				track.setCodecPrivate(new String(new byte[] { bytes[16], bytes[17], bytes[18], bytes[19] }));
				// [40, 0, 0, 0, -48, 2, 0, 0, 96, 1, 0, 0, 1, 0, 12, 0, 88, 86,
				// 73, 68, 0, 52, 23,
				// 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

			}
		}
	}

	private static MkvTrackType convertTrackType(byte value) {
		switch (value) {
		case 0x01:
			return MkvTrackType.VIDEO;
		case 0x02:
			return MkvTrackType.AUDIO;
		case 0x03:
			return MkvTrackType.COMPLEX;
		case 0x10:
			return MkvTrackType.LOGO;
		case 0x11:
			return MkvTrackType.SUBTITLE;
		case 0x20:
			return MkvTrackType.CONTROL;
		default:
			throw new RuntimeException("cannot convert track type from " + value);
		}
	}

	private static String convertBinaryToString(byte[] value) {
		return Arrays.toString(value);
	}
}
