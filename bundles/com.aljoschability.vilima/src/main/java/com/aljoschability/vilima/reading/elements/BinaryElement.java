package com.aljoschability.vilima.reading.elements;

import java.io.IOException;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public class BinaryElement extends AbstractEbmlElement {
	public BinaryElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	public byte[] readBinary(MatroskaEventReader reader) throws IOException {
		readData(reader);

		return getData();
	}
}
