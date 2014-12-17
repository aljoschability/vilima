package com.aljoschability.vilima.reading;

import java.io.IOException;
import java.nio.ByteBuffer;

import com.aljoschability.vilima.MkTrackType;

public class MkFileReaderSeekerExtension {
	private static final long UNIX_EPOCH_DELAY = 978307200;

	public static long bytesToLong(byte[] data) {
		long size = 0;
		long value = 0;
		for (int i = 0; i < data.length; i++) {
			value = (data[data.length - 1 - i] << 56) >>> 56;
			size |= (value << (8 * i));
		}
		return size;
	}

	private static char[] HEX = "0123456789ABCDEF".toCharArray();

	public static String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = HEX[v >>> 4];
			hexChars[j * 2 + 1] = HEX[v & 0x0F];
		}
		return new String(hexChars);
	}

	public static MkTrackType convertTrackType(byte value) {
		switch (value) {
		case 0x01:
			return MkTrackType.VIDEO;
		case 0x02:
			return MkTrackType.AUDIO;
		case 0x03:
			return MkTrackType.COMPLEX;
		case 0x10:
			return MkTrackType.LOGO;
		case 0x11:
			return MkTrackType.SUBTITLE;
		case 0x20:
			return MkTrackType.CONTROL;
		default:
			throw new RuntimeException("cannot convert track type from "
					+ value);
		}
	}

	public static long uintToLong(byte[] data) {
		long l = 0;
		long tmp = 0;
		for (int i = 0; i < data.length; i++) {
			tmp = ((long) data[data.length - 1 - i]) << 56;
			tmp >>>= (56 - (i * 8));
			l |= tmp;
		}
		return l;
	}

	public static EbmlElement createElement(byte[] id, byte[] dataSize) {
		int headerSize = id.length + dataSize.length;
		long size = bytesToLong(dataSize);
		MatroskaNode node = MatroskaNode.get(id);

		EbmlElement element;
		if (node == null) {
			element = new EbmlUnknownElement(id, headerSize, size);
		} else if (EbmlElementType.MASTER.equals(node.getType())) {
			element = new EbmlMasterElement(node, headerSize, size);
		} else {
			element = new EbmlDataElement(node, headerSize, size);
		}

		return element;
	}

	public static void clearFirstByte(ByteBuffer buffer, int length) {
		buffer.put(0, (byte) (buffer.get(0) & ((0xFF >>> length))));
	}

	public static int getLength(byte value) {
		int mask = 0x0080;
		for (int length = 0; length < 8; length++) {
			if ((value & mask) == mask) {
				return length + 1;
			}
			mask >>>= 1;
		}

		throw new RuntimeException();
	}

	public static long readTimestamp(byte[] data) throws IOException {
		long l = 0;
		long tmp = 0;
		l |= ((long) data[0] << (56 - ((8 - data.length) * 8)));
		for (int i = 1; i < data.length; i++) {
			tmp = ((long) data[data.length - i]) << 56;
			tmp >>>= 56 - (8 * (i - 1));
			l |= tmp;
		}

		l /= 1000000000;
		l += UNIX_EPOCH_DELAY;

		return l * 1000;
	}
}
