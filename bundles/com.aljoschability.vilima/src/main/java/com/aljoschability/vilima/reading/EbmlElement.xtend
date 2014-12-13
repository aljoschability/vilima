package com.aljoschability.vilima.reading;

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class EbmlElement {
	val byte[] id
	val EbmlElementType type
	val int headerSize
	val long size

	def long getTotalSize() { headerSize + size }

	def long getSkipSize()
}
