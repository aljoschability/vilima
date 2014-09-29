package com.aljoschability.vilima.reading.elements;

import java.io.IOException;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public class UnsignedIntegerElement extends BinaryElement {
	public UnsignedIntegerElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	public long getValue() {
		byte[] data = getData();

		long l = 0;
		long tmp = 0;
		for (int i = 0; i < data.length; i++) {
			tmp = ((long) data[data.length - 1 - i]) << 56;
			tmp >>>= (56 - (i * 8));
			l |= tmp;
		}
		return l;
	}

	public byte readByte(MatroskaEventReader reader) throws IOException {
		return (byte) readLong(reader);
	}

	public short readShort(MatroskaEventReader reader) throws IOException {
		return (short) readLong(reader);
	}

	public int readInt(MatroskaEventReader reader) throws IOException {
		return (int) readLong(reader);
	}

	public long readLong(MatroskaEventReader reader) throws IOException {
		readData(reader);

		return getValue();
	}
}
