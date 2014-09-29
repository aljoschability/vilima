package com.aljoschability.vilima.reading;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import com.aljoschability.vilima.MkvFile;
import com.aljoschability.vilima.MkvTag;
import com.aljoschability.vilima.MkvTagEntry;
import com.aljoschability.vilima.MkvTrack;
import com.aljoschability.vilima.MkvTrackType;
import com.aljoschability.vilima.VilimaFactory;
import com.aljoschability.vilima.reading.data.DataFrame;
import com.aljoschability.vilima.reading.elements.AbstractEbmlElement;
import com.aljoschability.vilima.reading.elements.BinaryElement;
import com.aljoschability.vilima.reading.elements.DateElement;
import com.aljoschability.vilima.reading.elements.FloatElement;
import com.aljoschability.vilima.reading.elements.MasterElement;
import com.aljoschability.vilima.reading.elements.SignedIntegerElement;
import com.aljoschability.vilima.reading.elements.SimpleBlockElement;
import com.aljoschability.vilima.reading.elements.StringElement;
import com.aljoschability.vilima.reading.elements.UnsignedIntegerElement;

public class MatroskaFile {
	private final boolean scanFirstCluster;

	private MatroskaEventReader reader;
	private MkvFile file;

	private final Collection<DataFrame> _DATA_frames;

	public MatroskaFile(boolean scanFirstCluster) throws FileNotFoundException {
		this.scanFirstCluster = scanFirstCluster;

		_DATA_frames = new ArrayList<>();
	}

	public void readFile(MkvFile file) throws IOException {
		reader = new MatroskaEventReader(Paths.get(file.getFilePath(), file.getFileName()).toString());
		this.file = file;

		readEbml();

		readSegmentRoot();
	}

	private void readEbml() throws IOException {
		AbstractEbmlElement element = reader.readNextElement();

		if (!MatroskaLiteral.EBML.matches(element)) {
			throw new RuntimeException("EBML root element could not be read.");
		}

		readEbmlDocType((MasterElement) element);
	}

	private void readEbmlDocType(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.DocType.matches(element)) {
				element.readData(reader);
				String value = ((StringElement) element).getValue();

				if (!(value.equals("matroska") || value.equals("webm"))) {
					throw new RuntimeException("EBML document type cannot be read.");
				}
			}

			element.skipData(reader);
		}
	}

	private void readSegmentRoot() throws IOException {
		AbstractEbmlElement element = reader.readNextElement();

		if (!MatroskaLiteral.Segment.matches(element)) {
			throw new RuntimeException("Segment not the second element in the file.");
		}

		readSegment((MasterElement) element);
	}

	private void readSegment(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Info.matches(element)) {
				readSegmentInfo((MasterElement) element);
			} else if (MatroskaLiteral.Tracks.matches(element)) {
				readTracks((MasterElement) element);
			} else if (MatroskaLiteral.Cluster.matches(element)) {
				if (scanFirstCluster) {
					_parseNextCluster((MasterElement) element);
				}

				return;
			} else if (MatroskaLiteral.Tags.matches(element)) {
				readTags((MasterElement) element);
			}

			element.skipData(reader);
		}
	}

	private void readSegmentInfo(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Title.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				file.setSegmentTitle(value);
			} else if (MatroskaLiteral.DateUTC.matches(element)) {
				long value = ((DateElement) element).readTimestamp(reader);

				file.setSegmentDate(value);
			} else if (MatroskaLiteral.MuxingApp.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				file.setSegmentMuxingApp(value);
			} else if (MatroskaLiteral.WritingApp.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				file.setSegmentWritingApp(value);
			} else if (MatroskaLiteral.Duration.matches(element)) {
				double value = ((FloatElement) element).readDouble(reader);

				file.setSegmentDuration(value);
			} else if (MatroskaLiteral.TimecodeScale.matches(element)) {
				long value = ((UnsignedIntegerElement) element).readLong(reader);

				file.setSegmentTimecodeScale(value);
			}

			element.skipData(reader);
		}
	}

	private void readTracks(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.TrackEntry.matches(element)) {
				readTrackEntry((MasterElement) element);
			}

			element.skipData(reader);
		}
	}

	private void readTrackEntry(MasterElement parent) throws IOException {
		MkvTrack track = VilimaFactory.eINSTANCE.createMkvTrack();

		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.TrackNumber.matches(element)) {
				int value = ((UnsignedIntegerElement) element).readInt(reader);

				track.setNumber(value);
			} else if (MatroskaLiteral.TrackUID.matches(element)) {
				long value = ((UnsignedIntegerElement) element).readLong(reader);

				track.setUid(value);
			} else if (MatroskaLiteral.TrackType.matches(element)) {
				byte value = ((UnsignedIntegerElement) element).readByte(reader);

				track.setType(convertTrackType(value));
			} else if (MatroskaLiteral.Name.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				track.setName(value);
			} else if (MatroskaLiteral.Language.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				track.setLanguage(value);
			} else if (MatroskaLiteral.CodecID.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				track.setCodecId(value);
			} else if (MatroskaLiteral.CodecPrivate.matches(element)) {
				byte[] value = ((BinaryElement) element).readBinary(reader);

				track.setCodecPrivate(convertBinaryToString(value));
			} else if (MatroskaLiteral.Video.matches(element)) {
				readTrackVideoDetails((MasterElement) element, track);
			} else if (MatroskaLiteral.Audio.matches(element)) {
				readTrackAudioDetails((MasterElement) element, track);
			}

			element.skipData(reader);
		}

		rewriteCodecPrivate(track);

		file.getTracks().add(track);
	}

	private void rewriteCodecPrivate(MkvTrack track) {
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
				// System.out.println(Arrays.toString(new byte[] { 'X', 'V', 'I', 'D' }));
				track.setCodecPrivate(new String(new byte[] { bytes[16], bytes[17], bytes[18], bytes[19] }));
				// [40, 0, 0, 0, -48, 2, 0, 0, 96, 1, 0, 0, 1, 0, 12, 0, 88, 86, 73, 68, 0, 52, 23,
				// 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

			}
		}
	}

	private String convertBinaryToString(byte[] value) {
		return Arrays.toString(value);
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

	private void readTrackAudioDetails(MasterElement parent, MkvTrack track) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.SamplingFrequency.matches(element)) {
				double value = ((FloatElement) element).readDouble(reader);

				track.setAudioSamplingFrequency(value);
			} else if (MatroskaLiteral.Channels.matches(element)) {
				short value = ((UnsignedIntegerElement) element).readShort(reader);

				track.setAudioChannels(value);
			}

			element.skipData(reader);
		}
	}

	private void readTrackVideoDetails(MasterElement parent, MkvTrack track) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.PixelWidth.matches(element)) {
				short value = ((UnsignedIntegerElement) element).readShort(reader);

				track.setVideoPixelWidth(value);
			} else if (MatroskaLiteral.PixelHeight.matches(element)) {
				short value = ((UnsignedIntegerElement) element).readShort(reader);

				track.setVideoPixelHeight(value);
			} else if (MatroskaLiteral.DisplayWidth.matches(element)) {
				short value = ((UnsignedIntegerElement) element).readShort(reader);

				track.setVideoDisplayWidth(value);
			} else if (MatroskaLiteral.DisplayHeight.matches(element)) {
				short value = ((UnsignedIntegerElement) element).readShort(reader);

				track.setVideoDisplayHeight(value);
			}

			element.skipData(reader);
		}
	}

	private void readTags(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Tag.matches(element)) {
				MkvTag tag = VilimaFactory.eINSTANCE.createMkvTag();

				readTag((MasterElement) element, tag);

				file.getTags().add(tag);
			}

			element.skipData(reader);
		}
	}

	private void readTag(MasterElement parent, MkvTag tag) throws IOException {
		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Targets.matches(element)) {
				readTagTargets((MasterElement) element, tag);
			} else if (MatroskaLiteral.SimpleTag.matches(element)) {
				tag.getEntries().add(readTagsSimpleTag((MasterElement) element));
			}

			element.skipData(reader);
		}
	}

	private void readTagTargets(MasterElement parent, MkvTag tag) throws IOException {
		AbstractEbmlElement element = null;
		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.TagTrackUID.matches(element)) {
				long value = ((UnsignedIntegerElement) element).readLong(reader);

				tag.setTrackUid(value);
			} else if (MatroskaLiteral.TagChapterUID.matches(element)) {
				long value = ((UnsignedIntegerElement) element).readLong(reader);

				tag.setChapterUid(value);
			} else if (MatroskaLiteral.TagAttachmentUID.matches(element)) {
				long value = ((UnsignedIntegerElement) element).readLong(reader);

				tag.setAttachmentUid(value);
			}

			element.skipData(reader);
		}
	}

	private MkvTagEntry readTagsSimpleTag(MasterElement parent) throws IOException {
		MkvTagEntry tag = VilimaFactory.eINSTANCE.createMkvTagEntry();

		AbstractEbmlElement element = null;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.TagName.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				tag.setName(value);
			} else if (MatroskaLiteral.TagString.matches(element)) {
				String value = ((StringElement) element).readString(reader);

				tag.setString(value);
			} else if (MatroskaLiteral.SimpleTag.matches(element)) {
				tag.getEntries().add(readTagsSimpleTag(parent));
			}

			element.skipData(reader);
		}

		return tag;
	}

	private void _parseNextCluster(MasterElement parent) throws IOException {
		AbstractEbmlElement element = null;

		long clusterTimecode = 0;
		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Timecode.matches(element)) {
				clusterTimecode = ((UnsignedIntegerElement) element).readLong(reader);
			} else if (MatroskaLiteral.SimpleBlock.matches(element)) {
				SimpleBlockElement block = (SimpleBlockElement) element;
				block.readData(reader);
				block.parseBlock();

				DataFrame frame = new DataFrame();
				frame.trackNumber = block.getTrackNumber();
				frame.timecode = block.getAdjustedBlockTimecode(clusterTimecode, file.getSegmentTimecodeScale());
				frame.duration = 0;
				frame.reference = 0;
				frame.data = block.getFrame(0);
				frame.keyFrame = block.isKeyframe();

				_DATA_frames.add(new DataFrame(frame));

				if (block.getFrameCount() > 1) {
					for (int f = 1; f < block.getFrameCount(); f++) {
						// frame.data = block.getFrame(f);
						// frameQueue.add(new MatroskaFileFrame(frame));
					}
				}

				element.skipData(reader);
			} else if (MatroskaLiteral.BlockGroup.matches(element)) {
				readClusterBlock((MasterElement) element, clusterTimecode);
			}

			element.skipData(reader);
		}
	}

	private void readClusterBlock(MasterElement parent, long clusterTimecode) throws IOException {
		AbstractEbmlElement element = null;

		SimpleBlockElement block = null;
		long duration = 0;
		long reference = 0;

		while ((element = parent.readNextChild(reader)) != null) {
			if (MatroskaLiteral.Block.matches(element)) {
				block = (SimpleBlockElement) element;
				block.readData(reader);
				block.parseBlock();
			} else if (MatroskaLiteral.BlockDuration.matches(element)) {
				element.readData(reader);
				duration = ((UnsignedIntegerElement) element).getValue();
			} else if (MatroskaLiteral.ReferenceBlock.matches(element)) {
				element.readData(reader);
				reference = ((SignedIntegerElement) element).getValue();
			}

			element.skipData(reader);
		}

		if (block == null) {
			throw new NullPointerException("BlockGroup element with no child Block!");
		}

		DataFrame frame = new DataFrame();
		frame.trackNumber = block.getTrackNumber();
		frame.timecode = block.getAdjustedBlockTimecode(clusterTimecode, file.getSegmentTimecodeScale());
		frame.duration = duration;
		frame.reference = reference;
		frame.data = block.getFrame(0);
		_DATA_frames.add(new DataFrame(frame));

		if (block.getFrameCount() > 1) {
			for (int f = 1; f < block.getFrameCount(); f++) {
				frame.data = block.getFrame(f);

				_DATA_frames.add(new DataFrame(frame));
			}
		}
	}

	@Override
	public String toString() {
		StringBuilder b = new StringBuilder();

		for (DataFrame dataFrame : _DATA_frames) {
			b.append(dataFrame);
		}

		b.append(file);

		return b.toString();
	}
}
