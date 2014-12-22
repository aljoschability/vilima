package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.extensions.impl.MatroskaFileReaderByteOperator

abstract class EbmlElement {
	val byte[] id
	val long size
	val int headerSize

	new(byte[] id, byte[] size) {
		this.id = id
		this.size = MatroskaFileReaderByteOperator::bytesToLongUnsigned(size)

		headerSize = id.length + size.length
	}

	/**
	 * Returns the node which this element represents.
	 */
	def MatroskaNode getNode() { MatroskaNode::get(id) }

	/**
	 * Returns the data size of the element.
	 */
	def long getSize() { size }

	/**
	 * Returns the header size of this element.
	 */
	def int getHeaderSize() { headerSize }

	/**
	 * Returns the length needed to skip this element.
	 */
	def long getSkipLength()
}
