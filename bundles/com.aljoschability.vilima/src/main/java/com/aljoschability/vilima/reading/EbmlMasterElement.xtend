package com.aljoschability.vilima.reading;

class EbmlMasterElement extends EbmlElement {
	long bytesParsed = 0

	new(byte[] id, byte[] dataSize) {
		super(id, dataSize)
	}

	override getSkipSize() { size - bytesParsed }

	def boolean hasNext() { bytesParsed < size }

	def void add(EbmlElement element) {
		bytesParsed += element.totalSize
	}

	def EbmlElement addChild(EbmlElement element) {
		if(element != null) {
			bytesParsed += element.totalSize
		}
		return element
	}
}
