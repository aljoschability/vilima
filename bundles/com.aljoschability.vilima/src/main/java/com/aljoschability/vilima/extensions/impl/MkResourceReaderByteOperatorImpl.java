package com.aljoschability.vilima.extensions.impl;

import java.nio.ByteBuffer;

import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator;

public class MkResourceReaderByteOperatorImpl implements MkResourceReaderByteOperator {
	private static final long TIME_OFFSET = 978307200;
	private static final char[] HEX = "0123456789ABCDEF".toCharArray();

	@Override
	public long bytesToLong(byte[] data) {
		long size = 0;
		long value = 0;
		for (int i = 0; i < data.length; i++) {
			value = (data[data.length - 1 - i] << 56) >>> 56;
			size |= (value << (8 * i));
		}
		return size;
	}

	@Override
	public long bytesToLongUnsigned(byte[] data) {
		long l = 0;
		long tmp = 0;
		for (int i = 0; i < data.length; i++) {
			tmp = ((long) data[data.length - 1 - i]) << 56;
			tmp >>>= (56 - (i * 8));
			l |= tmp;
		}
		return l;
	}

	@Override
	public String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = HEX[v >>> 4];
			hexChars[j * 2 + 1] = HEX[v & 0x0F];
		}
		return new String(hexChars);
	}

	@Override
	public void clearFirstByte(ByteBuffer buffer, int length) {
		buffer.put(0, (byte) (buffer.get(0) & ((0xFF >>> length))));
	}

	@Override
	public int getLength(byte value) {
		int mask = 0x0080;
		for (int length = 0; length < 8; length++) {
			if ((value & mask) == mask) {
				return length + 1;
			}
			mask >>>= 1;
		}

		throw new RuntimeException();
	}

	@Override
	public long readTimestamp(byte[] data) {
		long l = 0;
		long tmp = 0;
		l |= ((long) data[0] << (56 - ((8 - data.length) * 8)));
		for (int i = 1; i < data.length; i++) {
			tmp = ((long) data[data.length - i]) << 56;
			tmp >>>= 56 - (8 * (i - 1));
			l |= tmp;
		}

		l /= 1000000000;
		l += TIME_OFFSET;

		return l * 1000;
	}
}
