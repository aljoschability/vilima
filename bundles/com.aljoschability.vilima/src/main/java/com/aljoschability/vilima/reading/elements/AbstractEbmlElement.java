package com.aljoschability.vilima.reading.elements;

import java.io.IOException;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public abstract class AbstractEbmlElement {
	private final byte[] id;
	private final int headerSize;
	private final long size;

	protected byte[] data;

	private boolean dataRead;

	public AbstractEbmlElement(byte[] id, int headerSize, long size) {
		this.id = id;
		this.headerSize = headerSize;
		this.size = size;
	}

	public byte[] getId() {
		return id;
	}

	public long getSize() {
		return size;
	}

	public byte[] getData() {
		return this.data;
	}

	protected long getTotalSize() {
		return id.length + headerSize + size;
	}

	public void readData(MatroskaEventReader source) throws IOException {
		// Setup a buffer for it's data
		this.data = new byte[(int) size];

		// Read the data
		source.read(this.data, 0, this.data.length);

		dataRead = true;
	}

	public void skipData(MatroskaEventReader source) throws IOException {
		if (!dataRead) {
			// Skip the data
			source.skip(size);
			dataRead = true;
		}
	}
}
