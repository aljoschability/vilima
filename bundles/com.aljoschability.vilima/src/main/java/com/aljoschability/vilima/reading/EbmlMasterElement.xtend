package com.aljoschability.vilima.reading;

class EbmlMasterElement extends EbmlElement {
	long bytesParsed = 0

	new(byte[] id, byte[] dataSize) {
		super(id, dataSize)
	}

	/**
	 * Returns whether this element has elements to read left.
	 */
	def boolean hasNext() { bytesParsed < size }

	/**
	 * Adds the size of the given element to this elements parsed size and returns it untouched.
	 */
	def EbmlElement addChild(EbmlElement element) {
		if(element != null) {
			bytesParsed += element.headerSize + element.size
		}
		return element
	}

	override getSkipLength() { size - bytesParsed }
}
