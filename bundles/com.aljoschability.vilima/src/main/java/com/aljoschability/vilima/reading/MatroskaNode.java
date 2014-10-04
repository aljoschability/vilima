package com.aljoschability.vilima.reading;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

public enum MatroskaNode {
	EBML(toByteArray(0x1A, 0x45, 0xDF, 0xA3), EbmlElementType.MASTER),

	EBMLVersion(toByteArray(0x42, 0x86), EbmlElementType.UINTEGER),

	EBMLReadVersion(toByteArray(0x42, 0xF7), EbmlElementType.UINTEGER),

	EBMLMaxIDLength(toByteArray(0x42, 0xF2), EbmlElementType.UINTEGER),

	EBMLMaxSizeLength(toByteArray(0x42, 0xF3), EbmlElementType.UINTEGER),

	DocType(toByteArray(0x42, 0x82), EbmlElementType.ASCII),

	DocTypeVersion(toByteArray(0x42, 0x87), EbmlElementType.UINTEGER),

	DocTypeReadVersion(toByteArray(0x42, 0x85), EbmlElementType.UINTEGER),

	Void(toByteArray(0xEC), EbmlElementType.BINARY),

	CRC32(toByteArray(0xBF), EbmlElementType.BINARY),

	SignatureSlot(toByteArray(0x1B, 0x53, 0x86, 0x67), EbmlElementType.MASTER),

	SignatureAlgo(toByteArray(0x7E, 0x8A), EbmlElementType.UINTEGER),

	SignatureHash(toByteArray(0x7E, 0x9A), EbmlElementType.UINTEGER),

	SignaturePublicKey(toByteArray(0x7E, 0xA5), EbmlElementType.BINARY),

	Signature(toByteArray(0x7E, 0xB5), EbmlElementType.BINARY),

	SignatureElements(toByteArray(0x7E, 0x5B), EbmlElementType.MASTER),

	SignatureElementList(toByteArray(0x7E, 0x7B), EbmlElementType.MASTER),

	SignedElement(toByteArray(0x65, 0x32), EbmlElementType.BINARY),

	Segment(toByteArray(0x18, 0x53, 0x80, 0x67), EbmlElementType.MASTER),

	SeekHead(toByteArray(0x11, 0x4D, 0x9B, 0x74), EbmlElementType.MASTER),

	Seek(toByteArray(0x4D, 0xBB), EbmlElementType.MASTER),

	SeekID(toByteArray(0x53, 0xAB), EbmlElementType.BINARY),

	SeekPosition(toByteArray(0x53, 0xAC), EbmlElementType.UINTEGER),

	Info(toByteArray(0x15, 0x49, 0xA9, 0x66), EbmlElementType.MASTER),

	SegmentUID(toByteArray(0x73, 0xA4), EbmlElementType.BINARY),

	SegmentFilename(toByteArray(0x73, 0x84), EbmlElementType.STRING),

	PrevUID(toByteArray(0x3C, 0xB9, 0x23), EbmlElementType.BINARY),

	PrevFilename(toByteArray(0x3C, 0x83, 0xAB), EbmlElementType.STRING),

	NextUID(toByteArray(0x3E, 0xB9, 0x23), EbmlElementType.BINARY),

	NextFilename(toByteArray(0x3E, 0x83, 0xBB), EbmlElementType.STRING),

	SegmentFamily(toByteArray(0x44, 0x44), EbmlElementType.BINARY),

	ChapterTranslate(toByteArray(0x69, 0x24), EbmlElementType.MASTER),

	ChapterTranslateEditionUID(toByteArray(0x69, 0xFC), EbmlElementType.UINTEGER),

	ChapterTranslateCodec(toByteArray(0x69, 0xBF), EbmlElementType.UINTEGER),

	ChapterTranslateID(toByteArray(0x69, 0xA5), EbmlElementType.BINARY),

	TimecodeScale(toByteArray(0x2A, 0xD7, 0xB1), EbmlElementType.UINTEGER),

	Duration(toByteArray(0x44, 0x89), EbmlElementType.FLOAT),

	DateUTC(toByteArray(0x44, 0x61), EbmlElementType.DATE),

	Title(toByteArray(0x7B, 0xA9), EbmlElementType.STRING),

	MuxingApp(toByteArray(0x4D, 0x80), EbmlElementType.STRING),

	WritingApp(toByteArray(0x57, 0x41), EbmlElementType.STRING),

	Cluster(toByteArray(0x1F, 0x43, 0xB6, 0x75), EbmlElementType.MASTER),

	Timecode(toByteArray(0xE7), EbmlElementType.UINTEGER),

	SilentTracks(toByteArray(0x58, 0x54), EbmlElementType.MASTER),

	SilentTrackNumber(toByteArray(0x58, 0xD7), EbmlElementType.UINTEGER),

	Position(toByteArray(0xA7), EbmlElementType.UINTEGER),

	PrevSize(toByteArray(0xAB), EbmlElementType.UINTEGER),

	SimpleBlock(toByteArray(0xA3), EbmlElementType.MASTER),

	BlockGroup(toByteArray(0xA0), EbmlElementType.MASTER),

	Block(toByteArray(0xA1), EbmlElementType.MASTER),

	BlockVirtual(toByteArray(0xA2), EbmlElementType.BINARY),

	BlockAdditions(toByteArray(0x75, 0xA1), EbmlElementType.MASTER),

	BlockMore(toByteArray(0xA6), EbmlElementType.MASTER),

	BlockAddID(toByteArray(0xEE), EbmlElementType.UINTEGER),

	BlockAdditional(toByteArray(0xA5), EbmlElementType.BINARY),

	BlockDuration(toByteArray(0x9B), EbmlElementType.UINTEGER),

	ReferencePriority(toByteArray(0xFA), EbmlElementType.UINTEGER),

	ReferenceBlock(toByteArray(0xFB), EbmlElementType.INTEGER),

	ReferenceVirtual(toByteArray(0xFD), EbmlElementType.INTEGER),

	CodecState(toByteArray(0xA4), EbmlElementType.BINARY),

	DiscardPadding(toByteArray(0x75, 0xA2), EbmlElementType.INTEGER),

	Slices(toByteArray(0x8E), EbmlElementType.MASTER),

	TimeSlice(toByteArray(0xE8), EbmlElementType.MASTER),

	LaceNumber(toByteArray(0xCC), EbmlElementType.UINTEGER),

	FrameNumber(toByteArray(0xCD), EbmlElementType.UINTEGER),

	BlockAdditionID(toByteArray(0xCB), EbmlElementType.UINTEGER),

	Delay(toByteArray(0xCE), EbmlElementType.UINTEGER),

	SliceDuration(toByteArray(0xCF), EbmlElementType.UINTEGER),

	ReferenceFrame(toByteArray(0xC8), EbmlElementType.MASTER),

	ReferenceOffset(toByteArray(0xC9), EbmlElementType.UINTEGER),

	ReferenceTimeCode(toByteArray(0xCA), EbmlElementType.UINTEGER),

	EncryptedBlock(toByteArray(0xAF), EbmlElementType.BINARY),

	Tracks(toByteArray(0x16, 0x54, 0xAE, 0x6B), EbmlElementType.MASTER),

	TrackEntry(toByteArray(0xAE), EbmlElementType.MASTER),

	TrackNumber(toByteArray(0xD7), EbmlElementType.UINTEGER),

	TrackUID(toByteArray(0x73, 0xC5), EbmlElementType.UINTEGER),

	TrackType(toByteArray(0x83), EbmlElementType.UINTEGER),

	FlagEnabled(toByteArray(0xB9), EbmlElementType.UINTEGER),

	FlagDefault(toByteArray(0x88), EbmlElementType.UINTEGER),

	FlagForced(toByteArray(0x55, 0xAA), EbmlElementType.UINTEGER),

	FlagLacing(toByteArray(0x9C), EbmlElementType.UINTEGER),

	MinCache(toByteArray(0x6D, 0xE7), EbmlElementType.UINTEGER),

	MaxCache(toByteArray(0x6D, 0xF8), EbmlElementType.UINTEGER),

	DefaultDuration(toByteArray(0x23, 0xE3, 0x83), EbmlElementType.UINTEGER),

	DefaultDecodedFieldDuration(toByteArray(0x23, 0x4E, 0x7A), EbmlElementType.UINTEGER),

	TrackTimecodeScale(toByteArray(0x23, 0x31, 0x4F), EbmlElementType.FLOAT),

	TrackOffset(toByteArray(0x53, 0x7F), EbmlElementType.INTEGER),

	MaxBlockAdditionID(toByteArray(0x55, 0xEE), EbmlElementType.UINTEGER),

	Name(toByteArray(0x53, 0x6E), EbmlElementType.STRING),

	Language(toByteArray(0x22, 0xB5, 0x9C), EbmlElementType.ASCII),

	CodecID(toByteArray(0x86), EbmlElementType.ASCII),

	CodecPrivate(toByteArray(0x63, 0xA2), EbmlElementType.BINARY),

	CodecName(toByteArray(0x25, 0x86, 0x88), EbmlElementType.STRING),

	AttachmentLink(toByteArray(0x74, 0x46), EbmlElementType.UINTEGER),

	CodecSettings(toByteArray(0x3A, 0x96, 0x97), EbmlElementType.STRING),

	CodecInfoURL(toByteArray(0x3B, 0x40, 0x40), EbmlElementType.ASCII),

	CodecDownloadURL(toByteArray(0x26, 0xB2, 0x40), EbmlElementType.ASCII),

	CodecDecodeAll(toByteArray(0xAA), EbmlElementType.UINTEGER),

	TrackOverlay(toByteArray(0x6F, 0xAB), EbmlElementType.UINTEGER),

	CodecDelay(toByteArray(0x56, 0xAA), EbmlElementType.UINTEGER),

	SeekPreRoll(toByteArray(0x56, 0xBB), EbmlElementType.UINTEGER),

	TrackTranslate(toByteArray(0x66, 0x24), EbmlElementType.MASTER),

	TrackTranslateEditionUID(toByteArray(0x66, 0xFC), EbmlElementType.UINTEGER),

	TrackTranslateCodec(toByteArray(0x66, 0xBF), EbmlElementType.UINTEGER),

	TrackTranslateTrackID(toByteArray(0x66, 0xA5), EbmlElementType.BINARY),

	Video(toByteArray(0xE0), EbmlElementType.MASTER),

	FlagInterlaced(toByteArray(0x9A), EbmlElementType.UINTEGER),

	StereoMode(toByteArray(0x53, 0xB8), EbmlElementType.UINTEGER),

	AlphaMode(toByteArray(0x53, 0xC0), EbmlElementType.UINTEGER),

	PixelWidth(toByteArray(0xB0), EbmlElementType.UINTEGER),

	PixelHeight(toByteArray(0xBA), EbmlElementType.UINTEGER),

	PixelCropBottom(toByteArray(0x54, 0xAA), EbmlElementType.UINTEGER),

	PixelCropTop(toByteArray(0x54, 0xBB), EbmlElementType.UINTEGER),

	PixelCropLeft(toByteArray(0x54, 0xCC), EbmlElementType.UINTEGER),

	PixelCropRight(toByteArray(0x54, 0xDD), EbmlElementType.UINTEGER),

	DisplayWidth(toByteArray(0x54, 0xB0), EbmlElementType.UINTEGER),

	DisplayHeight(toByteArray(0x54, 0xBA), EbmlElementType.UINTEGER),

	DisplayUnit(toByteArray(0x54, 0xB2), EbmlElementType.UINTEGER),

	AspectRatioType(toByteArray(0x54, 0xB3), EbmlElementType.UINTEGER),

	ColourSpace(toByteArray(0x2E, 0xB5, 0x24), EbmlElementType.BINARY),

	GammaValue(toByteArray(0x2F, 0xB5, 0x23), EbmlElementType.FLOAT),

	FrameRate(toByteArray(0x23, 0x83, 0xE3), EbmlElementType.FLOAT),

	Audio(toByteArray(0xE1), EbmlElementType.MASTER),

	SamplingFrequency(toByteArray(0xB5), EbmlElementType.FLOAT),

	OutputSamplingFrequency(toByteArray(0x78, 0xB5), EbmlElementType.FLOAT),

	Channels(toByteArray(0x9F), EbmlElementType.UINTEGER),

	ChannelPositions(toByteArray(0x7D, 0x7B), EbmlElementType.BINARY),

	BitDepth(toByteArray(0x62, 0x64), EbmlElementType.UINTEGER),

	TrackOperation(toByteArray(0xE2), EbmlElementType.MASTER),

	TrackCombinePlanes(toByteArray(0xE3), EbmlElementType.MASTER),

	TrackPlane(toByteArray(0xE4), EbmlElementType.MASTER),

	TrackPlaneUID(toByteArray(0xE5), EbmlElementType.UINTEGER),

	TrackPlaneType(toByteArray(0xE6), EbmlElementType.UINTEGER),

	TrackJoinBlocks(toByteArray(0xE9), EbmlElementType.MASTER),

	TrackJoinUID(toByteArray(0xED), EbmlElementType.UINTEGER),

	TrickTrackUID(toByteArray(0xC0), EbmlElementType.UINTEGER),

	TrickTrackSegmentUID(toByteArray(0xC1), EbmlElementType.BINARY),

	TrickTrackFlag(toByteArray(0xC6), EbmlElementType.UINTEGER),

	TrickMasterTrackUID(toByteArray(0xC7), EbmlElementType.UINTEGER),

	TrickMasterTrackSegmentUID(toByteArray(0xC4), EbmlElementType.BINARY),

	ContentEncodings(toByteArray(0x6D, 0x80), EbmlElementType.MASTER),

	ContentEncoding(toByteArray(0x62, 0x40), EbmlElementType.MASTER),

	ContentEncodingOrder(toByteArray(0x50, 0x31), EbmlElementType.UINTEGER),

	ContentEncodingScope(toByteArray(0x50, 0x32), EbmlElementType.UINTEGER),

	ContentEncodingType(toByteArray(0x50, 0x33), EbmlElementType.UINTEGER),

	ContentCompression(toByteArray(0x50, 0x34), EbmlElementType.MASTER),

	ContentCompAlgo(toByteArray(0x42, 0x54), EbmlElementType.UINTEGER),

	ContentCompSettings(toByteArray(0x42, 0x55), EbmlElementType.BINARY),

	ContentEncryption(toByteArray(0x50, 0x35), EbmlElementType.MASTER),

	ContentEncAlgo(toByteArray(0x47, 0xE1), EbmlElementType.UINTEGER),

	ContentEncKeyID(toByteArray(0x47, 0xE2), EbmlElementType.BINARY),

	ContentSignature(toByteArray(0x47, 0xE3), EbmlElementType.BINARY),

	ContentSigKeyID(toByteArray(0x47, 0xE4), EbmlElementType.BINARY),

	ContentSigAlgo(toByteArray(0x47, 0xE5), EbmlElementType.UINTEGER),

	ContentSigHashAlgo(toByteArray(0x47, 0xE6), EbmlElementType.UINTEGER),

	Cues(toByteArray(0x1C, 0x53, 0xBB, 0x6B), EbmlElementType.MASTER),

	CuePoint(toByteArray(0xBB), EbmlElementType.MASTER),

	CueTime(toByteArray(0xB3), EbmlElementType.UINTEGER),

	CueTrackPositions(toByteArray(0xB7), EbmlElementType.MASTER),

	CueTrack(toByteArray(0xF7), EbmlElementType.UINTEGER),

	CueClusterPosition(toByteArray(0xF1), EbmlElementType.UINTEGER),

	CueRelativePosition(toByteArray(0xF0), EbmlElementType.UINTEGER),

	CueDuration(toByteArray(0xB2), EbmlElementType.UINTEGER),

	CueBlockNumber(toByteArray(0x53, 0x78), EbmlElementType.UINTEGER),

	CueCodecState(toByteArray(0xEA), EbmlElementType.UINTEGER),

	CueReference(toByteArray(0xDB), EbmlElementType.MASTER),

	CueRefTime(toByteArray(0x96), EbmlElementType.UINTEGER),

	CueRefCluster(toByteArray(0x97), EbmlElementType.UINTEGER),

	CueRefNumber(toByteArray(0x53, 0x5F), EbmlElementType.UINTEGER),

	CueRefCodecState(toByteArray(0xEB), EbmlElementType.UINTEGER),

	Attachments(toByteArray(0x19, 0x41, 0xA4, 0x69), EbmlElementType.MASTER),

	AttachedFile(toByteArray(0x61, 0xA7), EbmlElementType.MASTER),

	FileDescription(toByteArray(0x46, 0x7E), EbmlElementType.STRING),

	FileName(toByteArray(0x46, 0x6E), EbmlElementType.STRING),

	FileMimeType(toByteArray(0x46, 0x60), EbmlElementType.ASCII),

	FileData(toByteArray(0x46, 0x5C), EbmlElementType.BINARY),

	FileUID(toByteArray(0x46, 0xAE), EbmlElementType.UINTEGER),

	FileReferral(toByteArray(0x46, 0x75), EbmlElementType.BINARY),

	FileUsedStartTime(toByteArray(0x46, 0x61), EbmlElementType.UINTEGER),

	FileUsedEndTime(toByteArray(0x46, 0x62), EbmlElementType.UINTEGER),

	Chapters(toByteArray(0x10, 0x43, 0xA7, 0x70), EbmlElementType.MASTER),

	EditionEntry(toByteArray(0x45, 0xB9), EbmlElementType.MASTER),

	EditionUID(toByteArray(0x45, 0xBC), EbmlElementType.UINTEGER),

	EditionFlagHidden(toByteArray(0x45, 0xBD), EbmlElementType.UINTEGER),

	EditionFlagDefault(toByteArray(0x45, 0xDB), EbmlElementType.UINTEGER),

	EditionFlagOrdered(toByteArray(0x45, 0xDD), EbmlElementType.UINTEGER),

	ChapterAtom(toByteArray(0xB6), EbmlElementType.MASTER),

	ChapterUID(toByteArray(0x73, 0xC4), EbmlElementType.UINTEGER),

	ChapterStringUID(toByteArray(0x56, 0x54), EbmlElementType.STRING),

	ChapterTimeStart(toByteArray(0x91), EbmlElementType.UINTEGER),

	ChapterTimeEnd(toByteArray(0x92), EbmlElementType.UINTEGER),

	ChapterFlagHidden(toByteArray(0x98), EbmlElementType.UINTEGER),

	ChapterFlagEnabled(toByteArray(0x45, 0x98), EbmlElementType.UINTEGER),

	ChapterSegmentUID(toByteArray(0x6E, 0x67), EbmlElementType.BINARY),

	ChapterSegmentEditionUID(toByteArray(0x6E, 0xBC), EbmlElementType.UINTEGER),

	ChapterPhysicalEquiv(toByteArray(0x63, 0xC3), EbmlElementType.UINTEGER),

	ChapterTrack(toByteArray(0x8F), EbmlElementType.MASTER),

	ChapterTrackNumber(toByteArray(0x89), EbmlElementType.UINTEGER),

	ChapterDisplay(toByteArray(0x80), EbmlElementType.MASTER),

	ChapString(toByteArray(0x85), EbmlElementType.STRING),

	ChapLanguage(toByteArray(0x43, 0x7C), EbmlElementType.ASCII),

	ChapCountry(toByteArray(0x43, 0x7E), EbmlElementType.ASCII),

	ChapProcess(toByteArray(0x69, 0x44), EbmlElementType.MASTER),

	ChapProcessCodecID(toByteArray(0x69, 0x55), EbmlElementType.UINTEGER),

	ChapProcessPrivate(toByteArray(0x45, 0x0D), EbmlElementType.BINARY),

	ChapProcessCommand(toByteArray(0x69, 0x11), EbmlElementType.MASTER),

	ChapProcessTime(toByteArray(0x69, 0x22), EbmlElementType.UINTEGER),

	ChapProcessData(toByteArray(0x69, 0x33), EbmlElementType.BINARY),

	Tags(toByteArray(0x12, 0x54, 0xC3, 0x67), EbmlElementType.MASTER),

	Tag(toByteArray(0x73, 0x73), EbmlElementType.MASTER),

	Targets(toByteArray(0x63, 0xC0), EbmlElementType.MASTER),

	TargetTypeValue(toByteArray(0x68, 0xCA), EbmlElementType.UINTEGER),

	TargetType(toByteArray(0x63, 0xCA), EbmlElementType.ASCII),

	TagTrackUID(toByteArray(0x63, 0xC5), EbmlElementType.UINTEGER),

	TagEditionUID(toByteArray(0x63, 0xC9), EbmlElementType.UINTEGER),

	TagChapterUID(toByteArray(0x63, 0xC4), EbmlElementType.UINTEGER),

	TagAttachmentUID(toByteArray(0x63, 0xC6), EbmlElementType.UINTEGER),

	SimpleTag(toByteArray(0x67, 0xC8), EbmlElementType.MASTER),

	TagName(toByteArray(0x45, 0xA3), EbmlElementType.STRING),

	TagLanguage(toByteArray(0x44, 0x7A), EbmlElementType.ASCII),

	TagDefault(toByteArray(0x44, 0x84), EbmlElementType.UINTEGER),

	TagString(toByteArray(0x44, 0x87), EbmlElementType.STRING),

	TagBinary(toByteArray(0x44, 0x85), EbmlElementType.BINARY);

	private static final byte[] toByteArray(int... values) {
		byte[] bytes = new byte[values.length];

		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) values[i];
		}

		return bytes;
	}

	private static final Map<Integer, MatroskaNode> cache = new LinkedHashMap<>();
	static {
		for (MatroskaNode element : MatroskaNode.values()) {
			cache.put(Arrays.hashCode(element.id), element);
		}
	}

	private final byte[] id;
	private final EbmlElementType type;

	private MatroskaNode(byte[] id, EbmlElementType type) {
		this.id = id;
		this.type = type;
	}

	public byte[] getId() {
		return id;
	}

	public EbmlElementType getType() {
		return type;
	}

	public boolean matches(EbmlElement element) {
		return Arrays.equals(element.getId(), this.id);
	}

	public static MatroskaNode get(byte[] id) {
		return cache.get(Arrays.hashCode(id));
	}
}
