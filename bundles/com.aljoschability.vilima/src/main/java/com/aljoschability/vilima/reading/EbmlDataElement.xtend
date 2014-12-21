package com.aljoschability.vilima.reading;

class EbmlDataElement extends EbmlElement {
	byte[] data

	new(byte[] id, byte[] dataSize) {
		super(id, dataSize)
	}

	def void setData(byte[] data) {
		this.data = data
	}

	def boolean read() {
		data != null
	}

	override getSkipSize() {
		if(read()) {
			return 0
		} else {
			return getSize()
		}
	}

	def byte[] getData() {
		data
	}
}
