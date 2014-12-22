package com.aljoschability.vilima.reading;

class EbmlMasterElement extends EbmlElement {
	long bytesParsed = 0

	new(byte[] id, byte[] dataSize) {
		super(id, dataSize)
	}

	override getSkipLength() { size - bytesParsed }

	def boolean hasNext() { bytesParsed < size }

	def EbmlElement addChild(EbmlElement element) {
		if(element != null) {
			bytesParsed += element.headerSize + element.size
		}
		return element
	}
}
