package com.aljoschability.vilima.extensions

import java.nio.ByteBuffer
import com.aljoschability.vilima.extensions.impl.MkResourceReaderByteOperatorImpl

interface MkResourceReaderByteOperator {
	val INSTANCE = new MkResourceReaderByteOperatorImpl()

	def long bytesToLong(byte[] bytes)

	def long bytesToLongUnsigned(byte[] bytes)

	def String bytesToHex(byte[] bytes)

	def void clearFirstByte(ByteBuffer buffer, int value)

	def int getLength(byte value)

	def long readTimestamp(byte[] bytes)
}
