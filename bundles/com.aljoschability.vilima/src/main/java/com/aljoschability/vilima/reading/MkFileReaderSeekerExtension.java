package com.aljoschability.vilima.reading;

import java.io.IOException;
import java.nio.ByteBuffer;

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
