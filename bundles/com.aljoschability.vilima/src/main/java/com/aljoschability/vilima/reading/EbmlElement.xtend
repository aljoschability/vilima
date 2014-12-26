package com.aljoschability.vilima.reading;

abstract class EbmlElement {
	val MatroskaNode node
	val long size
	val int headerSize

	new(MatroskaNode node, int headerSize, long size) {
		this.node = node
		this.headerSize = headerSize
		this.size = size
	}

	/**
	 * Returns the node which this element represents.
	 */
	def MatroskaNode getNode() { node }

	/**
	 * Returns the header size of this element.
	 */
	def int getHeaderSize() { headerSize }

	/**
	 * Returns the data size of the element.
	 */
	def long getSize() { size }

	/**
	 * Returns the length needed to skip this element.
	 */
	def long getSkipLength()
}
