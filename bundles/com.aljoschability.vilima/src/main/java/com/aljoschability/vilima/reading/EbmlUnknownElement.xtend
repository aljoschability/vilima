package com.aljoschability.vilima.reading;

class EbmlUnknownElement extends EbmlElement {
	new(byte[] id, int headerSize, long size) {
		super(id, EbmlElementType::UNKNOWN, headerSize, size)
	}

	override getSkipSize() { 0 }
}
