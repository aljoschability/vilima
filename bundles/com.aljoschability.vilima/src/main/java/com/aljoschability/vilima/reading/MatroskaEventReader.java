package com.aljoschability.vilima.reading;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.SeekableByteChannel;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Arrays;

import com.aljoschability.vilima.reading.elements.AbstractEbmlElement;

public class MatroskaEventReader {
	@Deprecated
	private RandomAccessFile file;
	private SeekableByteChannel channel;

	public MatroskaEventReader(String filename) throws IOException {
		file = new RandomAccessFile(filename, "r");
		channel = Files.newByteChannel(Paths.get(filename), StandardOpenOption.READ);
	}

	public AbstractEbmlElement readNextElement() throws IOException {

		/***************************************************/
		// read EBML identifier
		byte[] _OLD_ID = _OLD_readElementId();
		// System.out.println("OLD[ ID ]=" + Arrays.toString(_OLD_ID));

		// read element size
		byte[] _OLD_SIZE = _OLD_readElementSize();
		long size = bytesToLong(_OLD_SIZE);
		// System.out.println("OLD[SIZE]=" + Arrays.toString(_OLD_SIZE) + " -> " + size);

		// TODO: live stream not implemented!
		// byte[] SIZE_LIVE = new byte[] { Byte.MAX_VALUE };
		// if (Arrays.equals(SIZE_LIVE, data)) {
		// System.out.println("found LIVE!");
		// }
		/***************************************************/

		// read element id
		 byte[] id = toArray(readElementId());
		// System.out.println("NEW[ ID ]=" + toString(id));

		// read element data size
		byte[] dataSize = toArray(readDataSize());
		// System.out.println("NEW[SIZE]=" + toString(dataSize) + " -> " + toLong(dataSize));
		// System.out.println();

		// check if old crap can be removed
		if (!Arrays.equals(_OLD_ID, id)) {
			System.out.println("####!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			System.out.println("# OLD[ ID ]=" + Arrays.toString(_OLD_ID));
			System.out.println("# NEW[ ID ]=" + Arrays.toString(id));
			System.out.println("####!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		}
		if (!Arrays.equals(_OLD_SIZE, dataSize)) {
			System.out.println("########################################");
			System.out.println("# OLD[SIZE]=" + bytesToLong(_OLD_SIZE) + Arrays.toString(_OLD_SIZE));
			System.out.println("# NEW[SIZE]=" + bytesToLong(dataSize) + Arrays.toString(dataSize));
			System.out.println("########################################");
		}

		return MatroskaLiteral.createElement(id, dataSize.length, bytesToLong(dataSize));
	}

	private ByteBuffer readElementId() throws IOException {
		final ByteBuffer buffer = ByteBuffer.allocateDirect(8);

		// read leading bit
		buffer.limit(1);
		if (channel.read(buffer) != 1) {
			throw new RuntimeException();
		}

		// convert length
		final int length = getLength(buffer.get(0));

		// read rest of id
		buffer.limit(length);
		if (channel.read(buffer) != length - 1) {
			throw new RuntimeException();
		}

		buffer.flip();

		return buffer;
	}

	private ByteBuffer readDataSize() throws IOException {
		final ByteBuffer buffer = ByteBuffer.allocateDirect(8);

		// read leading bit
		buffer.limit(1);
		if (channel.read(buffer) != 1) {
			throw new RuntimeException();
		}

		// convert length
		final int length = getLength(buffer.get(0));

		// read rest of id
		buffer.limit(length);
		if (channel.read(buffer) != length - 1) {
			throw new RuntimeException();
		}

		// clear the first byte
		buffer.put(0, (byte) (buffer.get(0) & ((0xFF >>> length))));

		buffer.flip();

		return buffer;
	}

	@Deprecated
	private byte[] _OLD_readElementSize() throws IOException {
		// insert first byte
		byte firstByte = file.readByte();

		int numBytes = getLength(firstByte);

		// Setup space to store the bits
		byte[] data = new byte[numBytes];

		// Clear the 1 at the front of this byte, all the way to the beginning of the size
		data[0] = (byte) (firstByte & ((0xFF >>> (numBytes))));

		// Read the rest of the size.
		file.read(data, 1, data.length - 1);

		return data;
	}

	@Deprecated
	private byte[] _OLD_readElementId() throws IOException {
		// insert first byte
		byte firstByte = file.readByte();

		int numBytes = getLength(firstByte);

		// Setup space to store the bits
		byte[] data = new byte[numBytes];

		data[0] = firstByte;

		// Read the rest of the size.
		file.read(data, 1, data.length - 1);

		return data;
	}

	public int read(byte[] buff, int offset, int length) throws IOException {
		ByteBuffer buffer = ByteBuffer.wrap(buff, offset, length);
		int resNew = channel.read(buffer);

		int resOld = file.read(buff, offset, length);

		if (resNew != resOld) {
			throw new RuntimeException();
		}
		return resOld;
	}

	public long skip(long offset) throws IOException {
		if (offset <= 0 || offset > Integer.MAX_VALUE) {
			return 0;
		}

		long pos = channel.position();
		long len = channel.size();
		long newpos = pos + offset;
		if (newpos > len) {
			newpos = len;
		}
		channel.position(newpos);

		long resNew = newpos - pos;
		long resOld = file.skipBytes((int) offset);

		if (resOld != resNew) {
			System.out.println();

			throw new RuntimeException();
		}

		return resOld;
	}

	private static int getLength(byte value) {
		int mask = 0x0080;
		for (int length = 0; length < 8; length++) {
			if ((value & mask) == mask) {
				return length + 1;
			}
			mask >>>= 1;
		}

		throw new RuntimeException();
	}

	private static long toLong(ByteBuffer buffer) {
		return bytesToLong(toArray(buffer));
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

	private static String toString(ByteBuffer buffer) {
		return Arrays.toString(toArray(buffer));
	}

	private static byte[] toArray(ByteBuffer buffer) {
		byte[] arr = new byte[buffer.limit()];
		buffer.get(arr);

		return arr;
	}
}
