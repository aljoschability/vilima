package com.aljoschability.vilima.reading;

public class EbmlMasterElement extends EbmlElement {
	private long readSize;

	public EbmlMasterElement(MatroskaNode node, int headerSize, long size) {
		super(node, headerSize, size);

		readSize = 0;
	}

	public long getSkipSize() {
		return getSize() - readSize;
	}

	public boolean hasNext() {
		return readSize < getSize();
	}

	public void add(EbmlElement element) {
		readSize += element.getTotalSize();
	}
}
