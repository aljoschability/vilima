package com.aljoschability.vilima.reading;

import java.util.Arrays;

import com.aljoschability.vilima.helpers.MatroskaReader;
import com.aljoschability.vilima.helpers.MkReaderByter;

public class EbmlUnknownElement extends EbmlElement {
	private final byte[] id;

	public EbmlUnknownElement(byte[] id, int headerSize, long size) {
		super(null, headerSize, size);

		this.id = id;

		System.out.println("NULL TYPE FOR byte[]=" + Arrays.toString(id) + " hex=" + MkReaderByter.bytesToHex(id));
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
