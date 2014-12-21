package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator

abstract class EbmlElement {
	val byte[] id
	val long size
	val int headerLength

	new(byte[] id, byte[] size) {
		this.id = id
		this.size = MkResourceReaderByteOperator::INSTANCE.bytesToLong(size)

		headerLength = id.length + size.length
	}

	/* Returns the node which this element represents. */
	def MatroskaNode getNode() {
		MatroskaNode::get(id)
	}

	/* Returns whether this element is a container node. */
	def boolean isContainer() {
		return node?.type == EbmlElementType::MASTER
	}

	def long getSize() {
		size
	}

	@Deprecated
	def long getTotalSize() {
		headerLength + size
	}

	@Deprecated
	def int getHeaderSize() {
		headerLength
	}

	@Deprecated
	def long getSkipSize()

	@Deprecated
	def EbmlElementType getType() {
		node?.type
	}
}
