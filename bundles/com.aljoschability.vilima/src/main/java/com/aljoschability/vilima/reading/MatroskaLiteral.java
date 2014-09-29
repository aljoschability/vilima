package com.aljoschability.vilima.reading;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

import com.aljoschability.vilima.reading.elements.AbstractEbmlElement;
import com.aljoschability.vilima.reading.elements.BinaryElement;
import com.aljoschability.vilima.reading.elements.DateElement;
import com.aljoschability.vilima.reading.elements.FloatElement;
import com.aljoschability.vilima.reading.elements.MasterElement;
import com.aljoschability.vilima.reading.elements.SignedIntegerElement;
import com.aljoschability.vilima.reading.elements.StringElement;
import com.aljoschability.vilima.reading.elements.UnsignedIntegerElement;

public enum MatroskaLiteral {
	EBML(toByteArray(0x1A, 0x45, 0xDF, 0xA3), EbmlDataType.MASTER),

	EBMLVersion(toByteArray(0x42, 0x86), EbmlDataType.UINTEGER),

	EBMLReadVersion(toByteArray(0x42, 0xF7), EbmlDataType.UINTEGER),

	EBMLMaxIDLength(toByteArray(0x42, 0xF2), EbmlDataType.UINTEGER),

	EBMLMaxSizeLength(toByteArray(0x42, 0xF3), EbmlDataType.UINTEGER),

	DocType(toByteArray(0x42, 0x82), EbmlDataType.ASCII),

	DocTypeVersion(toByteArray(0x42, 0x87), EbmlDataType.UINTEGER),

	DocTypeReadVersion(toByteArray(0x42, 0x85), EbmlDataType.UINTEGER),

	Void(toByteArray(0xEC), EbmlDataType.BINARY),

	CRC32(toByteArray(0xBF), EbmlDataType.BINARY),

	SignatureSlot(toByteArray(0x1B, 0x53, 0x86, 0x67), EbmlDataType.MASTER),

	SignatureAlgo(toByteArray(0x7E, 0x8A), EbmlDataType.UINTEGER),

	SignatureHash(toByteArray(0x7E, 0x9A), EbmlDataType.UINTEGER),

	SignaturePublicKey(toByteArray(0x7E, 0xA5), EbmlDataType.BINARY),

	Signature(toByteArray(0x7E, 0xB5), EbmlDataType.BINARY),

	SignatureElements(toByteArray(0x7E, 0x5B), EbmlDataType.MASTER),

	SignatureElementList(toByteArray(0x7E, 0x7B), EbmlDataType.MASTER),

	SignedElement(toByteArray(0x65, 0x32), EbmlDataType.BINARY),

	Segment(toByteArray(0x18, 0x53, 0x80, 0x67), EbmlDataType.MASTER),

	SeekHead(toByteArray(0x11, 0x4D, 0x9B, 0x74), EbmlDataType.MASTER),

	Seek(toByteArray(0x4D, 0xBB), EbmlDataType.MASTER),

	SeekID(toByteArray(0x53, 0xAB), EbmlDataType.BINARY),

	SeekPosition(toByteArray(0x53, 0xAC), EbmlDataType.UINTEGER),

	Info(toByteArray(0x15, 0x49, 0xA9, 0x66), EbmlDataType.MASTER),

	SegmentUID(toByteArray(0x73, 0xA4), EbmlDataType.BINARY),

	SegmentFilename(toByteArray(0x73, 0x84), EbmlDataType.STRING),

	PrevUID(toByteArray(0x3C, 0xB9, 0x23), EbmlDataType.BINARY),

	PrevFilename(toByteArray(0x3C, 0x83, 0xAB), EbmlDataType.STRING),

	NextUID(toByteArray(0x3E, 0xB9, 0x23), EbmlDataType.BINARY),

	NextFilename(toByteArray(0x3E, 0x83, 0xBB), EbmlDataType.STRING),

	SegmentFamily(toByteArray(0x44, 0x44), EbmlDataType.BINARY),

	ChapterTranslate(toByteArray(0x69, 0x24), EbmlDataType.MASTER),

	ChapterTranslateEditionUID(toByteArray(0x69, 0xFC), EbmlDataType.UINTEGER),

	ChapterTranslateCodec(toByteArray(0x69, 0xBF), EbmlDataType.UINTEGER),

	ChapterTranslateID(toByteArray(0x69, 0xA5), EbmlDataType.BINARY),

	TimecodeScale(toByteArray(0x2A, 0xD7, 0xB1), EbmlDataType.UINTEGER),

	Duration(toByteArray(0x44, 0x89), EbmlDataType.FLOAT),

	DateUTC(toByteArray(0x44, 0x61), EbmlDataType.DATE),

	Title(toByteArray(0x7B, 0xA9), EbmlDataType.STRING),

	MuxingApp(toByteArray(0x4D, 0x80), EbmlDataType.STRING),

	WritingApp(toByteArray(0x57, 0x41), EbmlDataType.STRING),

	Cluster(toByteArray(0x1F, 0x43, 0xB6, 0x75), EbmlDataType.MASTER),

	Timecode(toByteArray(0xE7), EbmlDataType.UINTEGER),

	SilentTracks(toByteArray(0x58, 0x54), EbmlDataType.MASTER),

	SilentTrackNumber(toByteArray(0x58, 0xD7), EbmlDataType.UINTEGER),

	Position(toByteArray(0xA7), EbmlDataType.UINTEGER),

	PrevSize(toByteArray(0xAB), EbmlDataType.UINTEGER),

	SimpleBlock(toByteArray(0xA3), EbmlDataType.BINARY),

	BlockGroup(toByteArray(0xA0), EbmlDataType.MASTER),

	Block(toByteArray(0xA1), EbmlDataType.BINARY),

	BlockVirtual(toByteArray(0xA2), EbmlDataType.BINARY),

	BlockAdditions(toByteArray(0x75, 0xA1), EbmlDataType.MASTER),

	BlockMore(toByteArray(0xA6), EbmlDataType.MASTER),

	BlockAddID(toByteArray(0xEE), EbmlDataType.UINTEGER),

	BlockAdditional(toByteArray(0xA5), EbmlDataType.BINARY),

	BlockDuration(toByteArray(0x9B), EbmlDataType.UINTEGER),

	ReferencePriority(toByteArray(0xFA), EbmlDataType.UINTEGER),

	ReferenceBlock(toByteArray(0xFB), EbmlDataType.INTEGER),

	ReferenceVirtual(toByteArray(0xFD), EbmlDataType.INTEGER),

	CodecState(toByteArray(0xA4), EbmlDataType.BINARY),

	DiscardPadding(toByteArray(0x75, 0xA2), EbmlDataType.INTEGER),

	Slices(toByteArray(0x8E), EbmlDataType.MASTER),

	TimeSlice(toByteArray(0xE8), EbmlDataType.MASTER),

	LaceNumber(toByteArray(0xCC), EbmlDataType.UINTEGER),

	FrameNumber(toByteArray(0xCD), EbmlDataType.UINTEGER),

	BlockAdditionID(toByteArray(0xCB), EbmlDataType.UINTEGER),

	Delay(toByteArray(0xCE), EbmlDataType.UINTEGER),

	SliceDuration(toByteArray(0xCF), EbmlDataType.UINTEGER),

	ReferenceFrame(toByteArray(0xC8), EbmlDataType.MASTER),

	ReferenceOffset(toByteArray(0xC9), EbmlDataType.UINTEGER),

	ReferenceTimeCode(toByteArray(0xCA), EbmlDataType.UINTEGER),

	EncryptedBlock(toByteArray(0xAF), EbmlDataType.BINARY),

	Tracks(toByteArray(0x16, 0x54, 0xAE, 0x6B), EbmlDataType.MASTER),

	TrackEntry(toByteArray(0xAE), EbmlDataType.MASTER),

	TrackNumber(toByteArray(0xD7), EbmlDataType.UINTEGER),

	TrackUID(toByteArray(0x73, 0xC5), EbmlDataType.UINTEGER),

	TrackType(toByteArray(0x83), EbmlDataType.UINTEGER),

	FlagEnabled(toByteArray(0xB9), EbmlDataType.UINTEGER),

	FlagDefault(toByteArray(0x88), EbmlDataType.UINTEGER),

	FlagForced(toByteArray(0x55, 0xAA), EbmlDataType.UINTEGER),

	FlagLacing(toByteArray(0x9C), EbmlDataType.UINTEGER),

	MinCache(toByteArray(0x6D, 0xE7), EbmlDataType.UINTEGER),

	MaxCache(toByteArray(0x6D, 0xF8), EbmlDataType.UINTEGER),

	DefaultDuration(toByteArray(0x23, 0xE3, 0x83), EbmlDataType.UINTEGER),

	DefaultDecodedFieldDuration(toByteArray(0x23, 0x4E, 0x7A), EbmlDataType.UINTEGER),

	TrackTimecodeScale(toByteArray(0x23, 0x31, 0x4F), EbmlDataType.FLOAT),

	TrackOffset(toByteArray(0x53, 0x7F), EbmlDataType.INTEGER),

	MaxBlockAdditionID(toByteArray(0x55, 0xEE), EbmlDataType.UINTEGER),

	Name(toByteArray(0x53, 0x6E), EbmlDataType.STRING),

	Language(toByteArray(0x22, 0xB5, 0x9C), EbmlDataType.ASCII),

	CodecID(toByteArray(0x86), EbmlDataType.ASCII),

	CodecPrivate(toByteArray(0x63, 0xA2), EbmlDataType.BINARY),

	CodecName(toByteArray(0x25, 0x86, 0x88), EbmlDataType.STRING),

	AttachmentLink(toByteArray(0x74, 0x46), EbmlDataType.UINTEGER),

	CodecSettings(toByteArray(0x3A, 0x96, 0x97), EbmlDataType.STRING),

	CodecInfoURL(toByteArray(0x3B, 0x40, 0x40), EbmlDataType.ASCII),

	CodecDownloadURL(toByteArray(0x26, 0xB2, 0x40), EbmlDataType.ASCII),

	CodecDecodeAll(toByteArray(0xAA), EbmlDataType.UINTEGER),

	TrackOverlay(toByteArray(0x6F, 0xAB), EbmlDataType.UINTEGER),

	CodecDelay(toByteArray(0x56, 0xAA), EbmlDataType.UINTEGER),

	SeekPreRoll(toByteArray(0x56, 0xBB), EbmlDataType.UINTEGER),

	TrackTranslate(toByteArray(0x66, 0x24), EbmlDataType.MASTER),

	TrackTranslateEditionUID(toByteArray(0x66, 0xFC), EbmlDataType.UINTEGER),

	TrackTranslateCodec(toByteArray(0x66, 0xBF), EbmlDataType.UINTEGER),

	TrackTranslateTrackID(toByteArray(0x66, 0xA5), EbmlDataType.BINARY),

	Video(toByteArray(0xE0), EbmlDataType.MASTER),

	FlagInterlaced(toByteArray(0x9A), EbmlDataType.UINTEGER),

	StereoMode(toByteArray(0x53, 0xB8), EbmlDataType.UINTEGER),

	AlphaMode(toByteArray(0x53, 0xC0), EbmlDataType.UINTEGER),

	PixelWidth(toByteArray(0xB0), EbmlDataType.UINTEGER),

	PixelHeight(toByteArray(0xBA), EbmlDataType.UINTEGER),

	PixelCropBottom(toByteArray(0x54, 0xAA), EbmlDataType.UINTEGER),

	PixelCropTop(toByteArray(0x54, 0xBB), EbmlDataType.UINTEGER),

	PixelCropLeft(toByteArray(0x54, 0xCC), EbmlDataType.UINTEGER),

	PixelCropRight(toByteArray(0x54, 0xDD), EbmlDataType.UINTEGER),

	DisplayWidth(toByteArray(0x54, 0xB0), EbmlDataType.UINTEGER),

	DisplayHeight(toByteArray(0x54, 0xBA), EbmlDataType.UINTEGER),

	DisplayUnit(toByteArray(0x54, 0xB2), EbmlDataType.UINTEGER),

	AspectRatioType(toByteArray(0x54, 0xB3), EbmlDataType.UINTEGER),

	ColourSpace(toByteArray(0x2E, 0xB5, 0x24), EbmlDataType.BINARY),

	GammaValue(toByteArray(0x2F, 0xB5, 0x23), EbmlDataType.FLOAT),

	FrameRate(toByteArray(0x23, 0x83, 0xE3), EbmlDataType.FLOAT),

	Audio(toByteArray(0xE1), EbmlDataType.MASTER),

	SamplingFrequency(toByteArray(0xB5), EbmlDataType.FLOAT),

	OutputSamplingFrequency(toByteArray(0x78, 0xB5), EbmlDataType.FLOAT),

	Channels(toByteArray(0x9F), EbmlDataType.UINTEGER),

	ChannelPositions(toByteArray(0x7D, 0x7B), EbmlDataType.BINARY),

	BitDepth(toByteArray(0x62, 0x64), EbmlDataType.UINTEGER),

	TrackOperation(toByteArray(0xE2), EbmlDataType.MASTER),

	TrackCombinePlanes(toByteArray(0xE3), EbmlDataType.MASTER),

	TrackPlane(toByteArray(0xE4), EbmlDataType.MASTER),

	TrackPlaneUID(toByteArray(0xE5), EbmlDataType.UINTEGER),

	TrackPlaneType(toByteArray(0xE6), EbmlDataType.UINTEGER),

	TrackJoinBlocks(toByteArray(0xE9), EbmlDataType.MASTER),

	TrackJoinUID(toByteArray(0xED), EbmlDataType.UINTEGER),

	TrickTrackUID(toByteArray(0xC0), EbmlDataType.UINTEGER),

	TrickTrackSegmentUID(toByteArray(0xC1), EbmlDataType.BINARY),

	TrickTrackFlag(toByteArray(0xC6), EbmlDataType.UINTEGER),

	TrickMasterTrackUID(toByteArray(0xC7), EbmlDataType.UINTEGER),

	TrickMasterTrackSegmentUID(toByteArray(0xC4), EbmlDataType.BINARY),

	ContentEncodings(toByteArray(0x6D, 0x80), EbmlDataType.MASTER),

	ContentEncoding(toByteArray(0x62, 0x40), EbmlDataType.MASTER),

	ContentEncodingOrder(toByteArray(0x50, 0x31), EbmlDataType.UINTEGER),

	ContentEncodingScope(toByteArray(0x50, 0x32), EbmlDataType.UINTEGER),

	ContentEncodingType(toByteArray(0x50, 0x33), EbmlDataType.UINTEGER),

	ContentCompression(toByteArray(0x50, 0x34), EbmlDataType.MASTER),

	ContentCompAlgo(toByteArray(0x42, 0x54), EbmlDataType.UINTEGER),

	ContentCompSettings(toByteArray(0x42, 0x55), EbmlDataType.BINARY),

	ContentEncryption(toByteArray(0x50, 0x35), EbmlDataType.MASTER),

	ContentEncAlgo(toByteArray(0x47, 0xE1), EbmlDataType.UINTEGER),

	ContentEncKeyID(toByteArray(0x47, 0xE2), EbmlDataType.BINARY),

	ContentSignature(toByteArray(0x47, 0xE3), EbmlDataType.BINARY),

	ContentSigKeyID(toByteArray(0x47, 0xE4), EbmlDataType.BINARY),

	ContentSigAlgo(toByteArray(0x47, 0xE5), EbmlDataType.UINTEGER),

	ContentSigHashAlgo(toByteArray(0x47, 0xE6), EbmlDataType.UINTEGER),

	Cues(toByteArray(0x1C, 0x53, 0xBB, 0x6B), EbmlDataType.MASTER),

	CuePoint(toByteArray(0xBB), EbmlDataType.MASTER),

	CueTime(toByteArray(0xB3), EbmlDataType.UINTEGER),

	CueTrackPositions(toByteArray(0xB7), EbmlDataType.MASTER),

	CueTrack(toByteArray(0xF7), EbmlDataType.UINTEGER),

	CueClusterPosition(toByteArray(0xF1), EbmlDataType.UINTEGER),

	CueRelativePosition(toByteArray(0xF0), EbmlDataType.UINTEGER),

	CueDuration(toByteArray(0xB2), EbmlDataType.UINTEGER),

	CueBlockNumber(toByteArray(0x53, 0x78), EbmlDataType.UINTEGER),

	CueCodecState(toByteArray(0xEA), EbmlDataType.UINTEGER),

	CueReference(toByteArray(0xDB), EbmlDataType.MASTER),

	CueRefTime(toByteArray(0x96), EbmlDataType.UINTEGER),

	CueRefCluster(toByteArray(0x97), EbmlDataType.UINTEGER),

	CueRefNumber(toByteArray(0x53, 0x5F), EbmlDataType.UINTEGER),

	CueRefCodecState(toByteArray(0xEB), EbmlDataType.UINTEGER),

	Attachments(toByteArray(0x19, 0x41, 0xA4, 0x69), EbmlDataType.MASTER),

	AttachedFile(toByteArray(0x61, 0xA7), EbmlDataType.MASTER),

	FileDescription(toByteArray(0x46, 0x7E), EbmlDataType.STRING),

	FileName(toByteArray(0x46, 0x6E), EbmlDataType.STRING),

	FileMimeType(toByteArray(0x46, 0x60), EbmlDataType.ASCII),

	FileData(toByteArray(0x46, 0x5C), EbmlDataType.BINARY),

	FileUID(toByteArray(0x46, 0xAE), EbmlDataType.UINTEGER),

	FileReferral(toByteArray(0x46, 0x75), EbmlDataType.BINARY),

	FileUsedStartTime(toByteArray(0x46, 0x61), EbmlDataType.UINTEGER),

	FileUsedEndTime(toByteArray(0x46, 0x62), EbmlDataType.UINTEGER),

	Chapters(toByteArray(0x10, 0x43, 0xA7, 0x70), EbmlDataType.MASTER),

	EditionEntry(toByteArray(0x45, 0xB9), EbmlDataType.MASTER),

	EditionUID(toByteArray(0x45, 0xBC), EbmlDataType.UINTEGER),

	EditionFlagHidden(toByteArray(0x45, 0xBD), EbmlDataType.UINTEGER),

	EditionFlagDefault(toByteArray(0x45, 0xDB), EbmlDataType.UINTEGER),

	EditionFlagOrdered(toByteArray(0x45, 0xDD), EbmlDataType.UINTEGER),

	ChapterAtom(toByteArray(0xB6), EbmlDataType.MASTER),

	ChapterUID(toByteArray(0x73, 0xC4), EbmlDataType.UINTEGER),

	ChapterStringUID(toByteArray(0x56, 0x54), EbmlDataType.STRING),

	ChapterTimeStart(toByteArray(0x91), EbmlDataType.UINTEGER),

	ChapterTimeEnd(toByteArray(0x92), EbmlDataType.UINTEGER),

	ChapterFlagHidden(toByteArray(0x98), EbmlDataType.UINTEGER),

	ChapterFlagEnabled(toByteArray(0x45, 0x98), EbmlDataType.UINTEGER),

	ChapterSegmentUID(toByteArray(0x6E, 0x67), EbmlDataType.BINARY),

	ChapterSegmentEditionUID(toByteArray(0x6E, 0xBC), EbmlDataType.UINTEGER),

	ChapterPhysicalEquiv(toByteArray(0x63, 0xC3), EbmlDataType.UINTEGER),

	ChapterTrack(toByteArray(0x8F), EbmlDataType.MASTER),

	ChapterTrackNumber(toByteArray(0x89), EbmlDataType.UINTEGER),

	ChapterDisplay(toByteArray(0x80), EbmlDataType.MASTER),

	ChapString(toByteArray(0x85), EbmlDataType.STRING),

	ChapLanguage(toByteArray(0x43, 0x7C), EbmlDataType.ASCII),

	ChapCountry(toByteArray(0x43, 0x7E), EbmlDataType.ASCII),

	ChapProcess(toByteArray(0x69, 0x44), EbmlDataType.MASTER),

	ChapProcessCodecID(toByteArray(0x69, 0x55), EbmlDataType.UINTEGER),

	ChapProcessPrivate(toByteArray(0x45, 0x0D), EbmlDataType.BINARY),

	ChapProcessCommand(toByteArray(0x69, 0x11), EbmlDataType.MASTER),

	ChapProcessTime(toByteArray(0x69, 0x22), EbmlDataType.UINTEGER),

	ChapProcessData(toByteArray(0x69, 0x33), EbmlDataType.BINARY),

	Tags(toByteArray(0x12, 0x54, 0xC3, 0x67), EbmlDataType.MASTER),

	Tag(toByteArray(0x73, 0x73), EbmlDataType.MASTER),

	Targets(toByteArray(0x63, 0xC0), EbmlDataType.MASTER),

	TargetTypeValue(toByteArray(0x68, 0xCA), EbmlDataType.UINTEGER),

	TargetType(toByteArray(0x63, 0xCA), EbmlDataType.ASCII),

	TagTrackUID(toByteArray(0x63, 0xC5), EbmlDataType.UINTEGER),

	TagEditionUID(toByteArray(0x63, 0xC9), EbmlDataType.UINTEGER),

	TagChapterUID(toByteArray(0x63, 0xC4), EbmlDataType.UINTEGER),

	TagAttachmentUID(toByteArray(0x63, 0xC6), EbmlDataType.UINTEGER),

	SimpleTag(toByteArray(0x67, 0xC8), EbmlDataType.MASTER),

	TagName(toByteArray(0x45, 0xA3), EbmlDataType.STRING),

	TagLanguage(toByteArray(0x44, 0x7A), EbmlDataType.ASCII),

	TagDefault(toByteArray(0x44, 0x84), EbmlDataType.UINTEGER),

	TagString(toByteArray(0x44, 0x87), EbmlDataType.STRING),

	TagBinary(toByteArray(0x44, 0x85), EbmlDataType.BINARY);

	private static final byte[] toByteArray(int... values) {
		byte[] bytes = new byte[values.length];

		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) values[i];
		}

		return bytes;
	}

	private static final Map<Integer, MatroskaLiteral> cache = new LinkedHashMap<>();
	static {
		for (MatroskaLiteral element : MatroskaLiteral.values()) {
			cache.put(Arrays.hashCode(element.id), element);
		}
	}

	private final byte[] id;
	private final EbmlDataType type;

	private MatroskaLiteral(byte[] id, EbmlDataType type) {
		this.id = id;
		this.type = type;
	}

	public boolean matches(AbstractEbmlElement element) {
		return Arrays.equals(element.getId(), this.id);
	}

	public static AbstractEbmlElement createElement(byte[] id, int headerSize, long size) {
		MatroskaLiteral element = cache.get(Arrays.hashCode(id));

		if (element == null) {
			//System.out.println("element not in cache. creating binary as default: " + id);
			return new BinaryElement(id, headerSize, size);
		}

		switch (element.type) {
		case ASCII:
			return new StringElement(id, headerSize, size, "US-ASCII");
		case BINARY:
			return new BinaryElement(id, headerSize, size);
		case DATE:
			return new DateElement(id, headerSize, size);
		case FLOAT:
			return new FloatElement(id, headerSize, size);
		case INTEGER:
			return new SignedIntegerElement(id, headerSize, size);
		case MASTER:
			return new MasterElement(id, headerSize, size);
		case STRING:
			return new StringElement(id, headerSize, size);
		case UINTEGER:
			return new UnsignedIntegerElement(id, headerSize, size);
		case BLOCK:
			System.out.println("could not create element for " + element.type);
			return null;
		case CLUSTER:
			System.out.println("could not create element for " + element.type);
			return null;
		default:
			System.out.println("could not create element for " + element.type);
			return null;
		}
	}
}
