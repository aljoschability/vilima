package com.aljoschability.vilima.reading;

public class EbmlDataElement extends EbmlElement {
	private byte[] data;

	public EbmlDataElement(MatroskaNode node, int headerSize, long size) {
		super(node, headerSize, size);
	}

	public void setData(byte[] data) {
		this.data = data;
	}

	public boolean read() {
		return data != null;
	}

	public long getSkipSize() {
		if (read()) {
			return 0;
		} else {
			return getSize();
		}
	}

	public byte[] getData() {
		return data;
	}
}
