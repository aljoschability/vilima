package com.aljoschability.vilima.reading;

class EbmlDataElement extends EbmlElement {
	byte[] data

	new(byte[] id, byte[] size) {
		super(id, size)
	}

	/**
	 * Returns the data when the element has already been read. Otherwise <code>null</code>.
	 */
	def byte[] getData() {
		data
	}

	/**
	 * Sets the elements data to the given value.
	 */
	def void setData(byte[] data) {
		this.data = data
	}

	override getSkipLength() {
		return if(data == null) {
			size
		} else {
			0
		}
	}
}
