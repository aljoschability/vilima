package com.aljoschability.vilima.reading;

class EbmlMasterElement extends EbmlElement {
	long readSize = 0

	new(MatroskaNode node, int headerSize, long size) {
		super(node.id, node.type, headerSize, size)
	}

	override getSkipSize() { size - readSize }

	def boolean hasNext() { readSize < size }

	def void add(EbmlElement element) {
		readSize += element.totalSize
	}
}
