package com.aljoschability.vilima.reading;

public abstract class EbmlElement {
	private final MatroskaNode node;
	private final int headerSize;
	private final long size;

	public EbmlElement(MatroskaNode node, int headerSize, long size) {
		this.node = node;
		this.headerSize = headerSize;
		this.size = size;
	}

	public abstract long getSkipSize();

	public byte[] getId() {
		return node.getId();
	}

	public EbmlElementType getType() {
		return node.getType();
	}

	public long getHeaderSize() {
		return headerSize;
	}

	public long getSize() {
		return size;
	}

	public long getTotalSize() {
		return headerSize + size;
	}
}
