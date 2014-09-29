package com.aljoschability.vilima.reading.elements;

public class SignedIntegerElement extends BinaryElement {
	public SignedIntegerElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	public long getValue() {
		byte[] data = getData();

		long l = 0;
		long tmp = 0;
		l |= ((long) data[0] << (56 - ((8 - data.length) * 8)));
		for (int i = 1; i < data.length; i++) {
			tmp = ((long) data[data.length - i]) << 56;
			tmp >>>= 56 - (8 * (i - 1));
			l |= tmp;
		}

		return l;
	}
}
