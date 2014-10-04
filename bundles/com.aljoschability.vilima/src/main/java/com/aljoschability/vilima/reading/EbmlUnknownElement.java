package com.aljoschability.vilima.reading;

import java.util.Arrays;

public class EbmlUnknownElement extends EbmlElement {
	private final byte[] id;

	public EbmlUnknownElement(byte[] id, int headerSize, long size) {
		super(null, headerSize, size);

		this.id = id;

		System.out.println("NULL TYPE FOR byte[]=" + Arrays.toString(id) + " hex=" + MatroskaReader.bytesToHex(id));
	}

	public byte[] getId() {
		return id;
	}

	public EbmlElementType getType() {
		return EbmlElementType.UNKNOWN;
	}

	@Override
	public long getSkipSize() {
		return 0;
	}
}
