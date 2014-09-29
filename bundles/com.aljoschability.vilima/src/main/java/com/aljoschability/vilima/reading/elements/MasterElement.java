package com.aljoschability.vilima.reading.elements;

import java.io.IOException;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public class MasterElement extends AbstractEbmlElement {
	private long readSize;

	public MasterElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);

		readSize = 0;
	}

	public AbstractEbmlElement readNextChild(MatroskaEventReader reader) throws IOException {
		if (readSize >= getSize()) {
			return null;
		}

		AbstractEbmlElement element = reader.readNextElement();
		if (element == null) {
			return null;
		}

		readSize += element.getTotalSize();

		return element;
	}

	public void skipData(MatroskaEventReader reader) throws IOException {
		reader.skip(getSize() - readSize);
	}
}
