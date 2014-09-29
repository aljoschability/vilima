package com.aljoschability.vilima.reading;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;

import com.aljoschability.vilima.reading.elements.AbstractEbmlElement;

public class MatroskaEventReader {
	private RandomAccessFile file;

	public MatroskaEventReader(String filename) throws FileNotFoundException {
		file = new RandomAccessFile(filename, "r");
	}

	private byte[] _readHead_TODO(boolean clearFirst) throws IOException {
		// insert first byte
		byte firstByte = file.readByte();

		int numBytes = _getIndexOfFirst_TODO(firstByte);

		// Setup space to store the bits
		byte[] data = new byte[numBytes];

		// Clear the 1 at the front of this byte, all the way to the beginning of the size
		if (clearFirst) {
			data[0] = (byte) (firstByte & ((0xFF >>> (data.length))));
		} else {
			data[0] = firstByte;
		}

		// Read the rest of the size.
		file.read(data, 1, data.length - 1);

		return data;
	}

	private static int _getIndexOfFirst_TODO(byte value) {
		int index = 0;

		// define mask for long
		long mask = 0x0080;

		for (int i = 0; i < 8; i++) {
			// search from beginning
			if ((value & mask) == mask) {
				// add size
				index = i + 1;

				// end loop
				i = 8;
			}
			mask >>>= 1;
		}

		return index;
	}

	public AbstractEbmlElement readNextElement() throws IOException {
		// read EBML identifier
		byte[] id = _readHead_TODO(false);

		// read element size
		byte[] sizeBytes = _readHead_TODO(true);
		long size = bytesToLong(sizeBytes);

		// TODO: live stream not implemented!
		// byte[] SIZE_LIVE = new byte[] { Byte.MAX_VALUE };
		// if (Arrays.equals(SIZE_LIVE, data)) {
		// System.out.println("found LIVE!");
		// }

		return MatroskaLiteral.createElement(id, sizeBytes.length, size);
	}

	public int read(byte[] buff, int offset, int length) throws IOException {
		return file.read(buff, offset, length);
	}

	public byte readByte() throws IOException {
		return file.readByte();
	}

	public long skip(long offset) throws IOException {
		return file.skipBytes((int) offset);
	}

	private static long bytesToLong(byte[] data) {
		long size = 0;
		long value = 0;
		for (int i = 0; i < data.length; i++) {
			value = (data[data.length - 1 - i] << 56) >>> 56;
			size |= (value << (8 * i));
		}
		return size;
	}
}
