package com.aljoschability.vilima.reading;

class EbmlUnknownElement extends EbmlElement {
	new(byte[] id, byte[] dataSize) {
		super(id, dataSize)
	}

	override getSkipSize() { 0 }
}
