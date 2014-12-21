package com.aljoschability.vilima.reading;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

public enum MatroskaNode {
	EBML(id(0x1A, 0x45, 0xDF, 0xA3), EbmlElementType.MASTER),

	EBMLVersion(id(0x42, 0x86), EbmlElementType.UINTEGER),

	EBMLReadVersion(id(0x42, 0xF7), EbmlElementType.UINTEGER),

	EBMLMaxIDLength(id(0x42, 0xF2), EbmlElementType.UINTEGER),

	EBMLMaxSizeLength(id(0x42, 0xF3), EbmlElementType.UINTEGER),

	DocType(id(0x42, 0x82), EbmlElementType.ASCII),

	DocTypeVersion(id(0x42, 0x87), EbmlElementType.UINTEGER),

	DocTypeReadVersion(id(0x42, 0x85), EbmlElementType.UINTEGER),

	Void(id(0xEC), EbmlElementType.BINARY),

	CRC32(id(0xBF), EbmlElementType.BINARY),

	SignatureSlot(id(0x1B, 0x53, 0x86, 0x67), EbmlElementType.MASTER),

	SignatureAlgo(id(0x7E, 0x8A), EbmlElementType.UINTEGER),

	SignatureHash(id(0x7E, 0x9A), EbmlElementType.UINTEGER),

	SignaturePublicKey(id(0x7E, 0xA5), EbmlElementType.BINARY),

	Signature(id(0x7E, 0xB5), EbmlElementType.BINARY),

	SignatureElements(id(0x7E, 0x5B), EbmlElementType.MASTER),

	SignatureElementList(id(0x7E, 0x7B), EbmlElementType.MASTER),

	SignedElement(id(0x65, 0x32), EbmlElementType.BINARY),

	Segment(id(0x18, 0x53, 0x80, 0x67), EbmlElementType.MASTER),

	SeekHead(id(0x11, 0x4D, 0x9B, 0x74), EbmlElementType.MASTER),

	Seek(id(0x4D, 0xBB), EbmlElementType.MASTER),

	SeekID(id(0x53, 0xAB), EbmlElementType.BINARY),

	SeekPosition(id(0x53, 0xAC), EbmlElementType.UINTEGER),

	Info(id(0x15, 0x49, 0xA9, 0x66), EbmlElementType.MASTER),

	SegmentUID(id(0x73, 0xA4), EbmlElementType.BINARY),

	SegmentFilename(id(0x73, 0x84), EbmlElementType.STRING),

	PrevUID(id(0x3C, 0xB9, 0x23), EbmlElementType.BINARY),

	PrevFilename(id(0x3C, 0x83, 0xAB), EbmlElementType.STRING),

	NextUID(id(0x3E, 0xB9, 0x23), EbmlElementType.BINARY),

	NextFilename(id(0x3E, 0x83, 0xBB), EbmlElementType.STRING),

	SegmentFamily(id(0x44, 0x44), EbmlElementType.BINARY),

	ChapterTranslate(id(0x69, 0x24), EbmlElementType.MASTER),

	ChapterTranslateEditionUID(id(0x69, 0xFC), EbmlElementType.UINTEGER),

	ChapterTranslateCodec(id(0x69, 0xBF), EbmlElementType.UINTEGER),

	ChapterTranslateID(id(0x69, 0xA5), EbmlElementType.BINARY),

	TimecodeScale(id(0x2A, 0xD7, 0xB1), EbmlElementType.UINTEGER),

	Duration(id(0x44, 0x89), EbmlElementType.FLOAT),

	DateUTC(id(0x44, 0x61), EbmlElementType.DATE),

	Title(id(0x7B, 0xA9), EbmlElementType.STRING),

	MuxingApp(id(0x4D, 0x80), EbmlElementType.STRING),

	WritingApp(id(0x57, 0x41), EbmlElementType.STRING),

	Cluster(id(0x1F, 0x43, 0xB6, 0x75), EbmlElementType.MASTER),

	Timecode(id(0xE7), EbmlElementType.UINTEGER),

	SilentTracks(id(0x58, 0x54), EbmlElementType.MASTER),

	SilentTrackNumber(id(0x58, 0xD7), EbmlElementType.UINTEGER),

	Position(id(0xA7), EbmlElementType.UINTEGER),

	PrevSize(id(0xAB), EbmlElementType.UINTEGER),

	SimpleBlock(id(0xA3), EbmlElementType.MASTER),

	BlockGroup(id(0xA0), EbmlElementType.MASTER),

	Block(id(0xA1), EbmlElementType.MASTER),

	BlockVirtual(id(0xA2), EbmlElementType.BINARY),

	BlockAdditions(id(0x75, 0xA1), EbmlElementType.MASTER),

	BlockMore(id(0xA6), EbmlElementType.MASTER),

	BlockAddID(id(0xEE), EbmlElementType.UINTEGER),

	BlockAdditional(id(0xA5), EbmlElementType.BINARY),

	BlockDuration(id(0x9B), EbmlElementType.UINTEGER),

	ReferencePriority(id(0xFA), EbmlElementType.UINTEGER),

	ReferenceBlock(id(0xFB), EbmlElementType.INTEGER),

	ReferenceVirtual(id(0xFD), EbmlElementType.INTEGER),

	CodecState(id(0xA4), EbmlElementType.BINARY),

	DiscardPadding(id(0x75, 0xA2), EbmlElementType.INTEGER),

	Slices(id(0x8E), EbmlElementType.MASTER),

	TimeSlice(id(0xE8), EbmlElementType.MASTER),

	LaceNumber(id(0xCC), EbmlElementType.UINTEGER),

	FrameNumber(id(0xCD), EbmlElementType.UINTEGER),

	BlockAdditionID(id(0xCB), EbmlElementType.UINTEGER),

	Delay(id(0xCE), EbmlElementType.UINTEGER),

	SliceDuration(id(0xCF), EbmlElementType.UINTEGER),

	ReferenceFrame(id(0xC8), EbmlElementType.MASTER),

	ReferenceOffset(id(0xC9), EbmlElementType.UINTEGER),

	ReferenceTimeCode(id(0xCA), EbmlElementType.UINTEGER),

	EncryptedBlock(id(0xAF), EbmlElementType.BINARY),

	Tracks(id(0x16, 0x54, 0xAE, 0x6B), EbmlElementType.MASTER),

	TrackEntry(id(0xAE), EbmlElementType.MASTER),

	TrackNumber(id(0xD7), EbmlElementType.UINTEGER),

	TrackUID(id(0x73, 0xC5), EbmlElementType.UINTEGER),

	TrackType(id(0x83), EbmlElementType.UINTEGER),

	FlagEnabled(id(0xB9), EbmlElementType.UINTEGER),

	FlagDefault(id(0x88), EbmlElementType.UINTEGER),

	FlagForced(id(0x55, 0xAA), EbmlElementType.UINTEGER),

	FlagLacing(id(0x9C), EbmlElementType.UINTEGER),

	MinCache(id(0x6D, 0xE7), EbmlElementType.UINTEGER),

	MaxCache(id(0x6D, 0xF8), EbmlElementType.UINTEGER),

	DefaultDuration(id(0x23, 0xE3, 0x83), EbmlElementType.UINTEGER),

	DefaultDecodedFieldDuration(id(0x23, 0x4E, 0x7A), EbmlElementType.UINTEGER),

	TrackTimecodeScale(id(0x23, 0x31, 0x4F), EbmlElementType.FLOAT),

	TrackOffset(id(0x53, 0x7F), EbmlElementType.INTEGER),

	MaxBlockAdditionID(id(0x55, 0xEE), EbmlElementType.UINTEGER),

	Name(id(0x53, 0x6E), EbmlElementType.STRING),

	Language(id(0x22, 0xB5, 0x9C), EbmlElementType.ASCII),

	CodecID(id(0x86), EbmlElementType.ASCII),

	CodecPrivate(id(0x63, 0xA2), EbmlElementType.BINARY),

	CodecName(id(0x25, 0x86, 0x88), EbmlElementType.STRING),

	AttachmentLink(id(0x74, 0x46), EbmlElementType.UINTEGER),

	CodecSettings(id(0x3A, 0x96, 0x97), EbmlElementType.STRING),

	CodecInfoURL(id(0x3B, 0x40, 0x40), EbmlElementType.ASCII),

	CodecDownloadURL(id(0x26, 0xB2, 0x40), EbmlElementType.ASCII),

	CodecDecodeAll(id(0xAA), EbmlElementType.UINTEGER),

	TrackOverlay(id(0x6F, 0xAB), EbmlElementType.UINTEGER),

	CodecDelay(id(0x56, 0xAA), EbmlElementType.UINTEGER),

	SeekPreRoll(id(0x56, 0xBB), EbmlElementType.UINTEGER),

	TrackTranslate(id(0x66, 0x24), EbmlElementType.MASTER),

	TrackTranslateEditionUID(id(0x66, 0xFC), EbmlElementType.UINTEGER),

	TrackTranslateCodec(id(0x66, 0xBF), EbmlElementType.UINTEGER),

	TrackTranslateTrackID(id(0x66, 0xA5), EbmlElementType.BINARY),

	Video(id(0xE0), EbmlElementType.MASTER),

	FlagInterlaced(id(0x9A), EbmlElementType.UINTEGER),

	StereoMode(id(0x53, 0xB8), EbmlElementType.UINTEGER),

	AlphaMode(id(0x53, 0xC0), EbmlElementType.UINTEGER),

	PixelWidth(id(0xB0), EbmlElementType.UINTEGER),

	PixelHeight(id(0xBA), EbmlElementType.UINTEGER),

	PixelCropBottom(id(0x54, 0xAA), EbmlElementType.UINTEGER),

	PixelCropTop(id(0x54, 0xBB), EbmlElementType.UINTEGER),

	PixelCropLeft(id(0x54, 0xCC), EbmlElementType.UINTEGER),

	PixelCropRight(id(0x54, 0xDD), EbmlElementType.UINTEGER),

	DisplayWidth(id(0x54, 0xB0), EbmlElementType.UINTEGER),

	DisplayHeight(id(0x54, 0xBA), EbmlElementType.UINTEGER),

	DisplayUnit(id(0x54, 0xB2), EbmlElementType.UINTEGER),

	AspectRatioType(id(0x54, 0xB3), EbmlElementType.UINTEGER),

	ColourSpace(id(0x2E, 0xB5, 0x24), EbmlElementType.BINARY),

	GammaValue(id(0x2F, 0xB5, 0x23), EbmlElementType.FLOAT),

	FrameRate(id(0x23, 0x83, 0xE3), EbmlElementType.FLOAT),

	Audio(id(0xE1), EbmlElementType.MASTER),

	SamplingFrequency(id(0xB5), EbmlElementType.FLOAT),

	OutputSamplingFrequency(id(0x78, 0xB5), EbmlElementType.FLOAT),

	Channels(id(0x9F), EbmlElementType.UINTEGER),

	ChannelPositions(id(0x7D, 0x7B), EbmlElementType.BINARY),

	BitDepth(id(0x62, 0x64), EbmlElementType.UINTEGER),

	TrackOperation(id(0xE2), EbmlElementType.MASTER),

	TrackCombinePlanes(id(0xE3), EbmlElementType.MASTER),

	TrackPlane(id(0xE4), EbmlElementType.MASTER),

	TrackPlaneUID(id(0xE5), EbmlElementType.UINTEGER),

	TrackPlaneType(id(0xE6), EbmlElementType.UINTEGER),

	TrackJoinBlocks(id(0xE9), EbmlElementType.MASTER),

	TrackJoinUID(id(0xED), EbmlElementType.UINTEGER),

	TrickTrackUID(id(0xC0), EbmlElementType.UINTEGER),

	TrickTrackSegmentUID(id(0xC1), EbmlElementType.BINARY),

	TrickTrackFlag(id(0xC6), EbmlElementType.UINTEGER),

	TrickMasterTrackUID(id(0xC7), EbmlElementType.UINTEGER),

	TrickMasterTrackSegmentUID(id(0xC4), EbmlElementType.BINARY),

	ContentEncodings(id(0x6D, 0x80), EbmlElementType.MASTER),

	ContentEncoding(id(0x62, 0x40), EbmlElementType.MASTER),

	ContentEncodingOrder(id(0x50, 0x31), EbmlElementType.UINTEGER),

	ContentEncodingScope(id(0x50, 0x32), EbmlElementType.UINTEGER),

	ContentEncodingType(id(0x50, 0x33), EbmlElementType.UINTEGER),

	ContentCompression(id(0x50, 0x34), EbmlElementType.MASTER),

	ContentCompAlgo(id(0x42, 0x54), EbmlElementType.UINTEGER),

	ContentCompSettings(id(0x42, 0x55), EbmlElementType.BINARY),

	ContentEncryption(id(0x50, 0x35), EbmlElementType.MASTER),

	ContentEncAlgo(id(0x47, 0xE1), EbmlElementType.UINTEGER),

	ContentEncKeyID(id(0x47, 0xE2), EbmlElementType.BINARY),

	ContentSignature(id(0x47, 0xE3), EbmlElementType.BINARY),

	ContentSigKeyID(id(0x47, 0xE4), EbmlElementType.BINARY),

	ContentSigAlgo(id(0x47, 0xE5), EbmlElementType.UINTEGER),

	ContentSigHashAlgo(id(0x47, 0xE6), EbmlElementType.UINTEGER),

	Cues(id(0x1C, 0x53, 0xBB, 0x6B), EbmlElementType.MASTER),

	CuePoint(id(0xBB), EbmlElementType.MASTER),

	CueTime(id(0xB3), EbmlElementType.UINTEGER),

	CueTrackPositions(id(0xB7), EbmlElementType.MASTER),

	CueTrack(id(0xF7), EbmlElementType.UINTEGER),

	CueClusterPosition(id(0xF1), EbmlElementType.UINTEGER),

	CueRelativePosition(id(0xF0), EbmlElementType.UINTEGER),

	CueDuration(id(0xB2), EbmlElementType.UINTEGER),

	CueBlockNumber(id(0x53, 0x78), EbmlElementType.UINTEGER),

	CueCodecState(id(0xEA), EbmlElementType.UINTEGER),

	CueReference(id(0xDB), EbmlElementType.MASTER),

	CueRefTime(id(0x96), EbmlElementType.UINTEGER),

	CueRefCluster(id(0x97), EbmlElementType.UINTEGER),

	CueRefNumber(id(0x53, 0x5F), EbmlElementType.UINTEGER),

	CueRefCodecState(id(0xEB), EbmlElementType.UINTEGER),

	Attachments(id(0x19, 0x41, 0xA4, 0x69), EbmlElementType.MASTER),

	AttachedFile(id(0x61, 0xA7), EbmlElementType.MASTER),

	FileDescription(id(0x46, 0x7E), EbmlElementType.STRING),

	FileName(id(0x46, 0x6E), EbmlElementType.STRING),

	FileMimeType(id(0x46, 0x60), EbmlElementType.ASCII),

	FileData(id(0x46, 0x5C), EbmlElementType.BINARY),

	FileUID(id(0x46, 0xAE), EbmlElementType.UINTEGER),

	FileReferral(id(0x46, 0x75), EbmlElementType.BINARY),

	FileUsedStartTime(id(0x46, 0x61), EbmlElementType.UINTEGER),

	FileUsedEndTime(id(0x46, 0x62), EbmlElementType.UINTEGER),

	Chapters(id(0x10, 0x43, 0xA7, 0x70), EbmlElementType.MASTER),

	EditionEntry(id(0x45, 0xB9), EbmlElementType.MASTER),

	EditionUID(id(0x45, 0xBC), EbmlElementType.UINTEGER),

	EditionFlagHidden(id(0x45, 0xBD), EbmlElementType.UINTEGER),

	EditionFlagDefault(id(0x45, 0xDB), EbmlElementType.UINTEGER),

	EditionFlagOrdered(id(0x45, 0xDD), EbmlElementType.UINTEGER),

	ChapterAtom(id(0xB6), EbmlElementType.MASTER),

	ChapterUID(id(0x73, 0xC4), EbmlElementType.UINTEGER),

	ChapterStringUID(id(0x56, 0x54), EbmlElementType.STRING),

	ChapterTimeStart(id(0x91), EbmlElementType.UINTEGER),

	ChapterTimeEnd(id(0x92), EbmlElementType.UINTEGER),

	ChapterFlagHidden(id(0x98), EbmlElementType.UINTEGER),

	ChapterFlagEnabled(id(0x45, 0x98), EbmlElementType.UINTEGER),

	ChapterSegmentUID(id(0x6E, 0x67), EbmlElementType.BINARY),

	ChapterSegmentEditionUID(id(0x6E, 0xBC), EbmlElementType.UINTEGER),

	ChapterPhysicalEquiv(id(0x63, 0xC3), EbmlElementType.UINTEGER),

	ChapterTrack(id(0x8F), EbmlElementType.MASTER),

	ChapterTrackNumber(id(0x89), EbmlElementType.UINTEGER),

	ChapterDisplay(id(0x80), EbmlElementType.MASTER),

	ChapString(id(0x85), EbmlElementType.STRING),

	ChapLanguage(id(0x43, 0x7C), EbmlElementType.ASCII),

	ChapCountry(id(0x43, 0x7E), EbmlElementType.ASCII),

	ChapProcess(id(0x69, 0x44), EbmlElementType.MASTER),

	ChapProcessCodecID(id(0x69, 0x55), EbmlElementType.UINTEGER),

	ChapProcessPrivate(id(0x45, 0x0D), EbmlElementType.BINARY),

	ChapProcessCommand(id(0x69, 0x11), EbmlElementType.MASTER),

	ChapProcessTime(id(0x69, 0x22), EbmlElementType.UINTEGER),

	ChapProcessData(id(0x69, 0x33), EbmlElementType.BINARY),

	Tags(id(0x12, 0x54, 0xC3, 0x67), EbmlElementType.MASTER),

	Tag(id(0x73, 0x73), EbmlElementType.MASTER),

	Targets(id(0x63, 0xC0), EbmlElementType.MASTER),

	TargetTypeValue(id(0x68, 0xCA), EbmlElementType.UINTEGER),

	TargetType(id(0x63, 0xCA), EbmlElementType.ASCII),

	TagTrackUID(id(0x63, 0xC5), EbmlElementType.UINTEGER),

	TagEditionUID(id(0x63, 0xC9), EbmlElementType.UINTEGER),

	TagChapterUID(id(0x63, 0xC4), EbmlElementType.UINTEGER),

	TagAttachmentUID(id(0x63, 0xC6), EbmlElementType.UINTEGER),

	SimpleTag(id(0x67, 0xC8), EbmlElementType.MASTER),

	TagName(id(0x45, 0xA3), EbmlElementType.STRING),

	TagLanguage(id(0x44, 0x7A), EbmlElementType.ASCII),

	TagDefault(id(0x44, 0x84), EbmlElementType.UINTEGER),

	TagString(id(0x44, 0x87), EbmlElementType.STRING),

	TagBinary(id(0x44, 0x85), EbmlElementType.BINARY);

	private static final byte[] id(int... values) {
		byte[] bytes = new byte[values.length];

		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) values[i];
		}

		return bytes;
	}

	private static final Map<Integer, MatroskaNode> CACHE = new LinkedHashMap<>();
	static {
		for (MatroskaNode element : MatroskaNode.values()) {
			CACHE.put(Arrays.hashCode(element.id), element);
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

	public static MatroskaNode get(byte[] id) {
		return CACHE.get(Arrays.hashCode(id));
	}
}
