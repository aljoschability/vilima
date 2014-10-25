package com.aljoschability.vilima.reading;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SeekableByteChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

import com.google.common.base.Charsets;

public final class MatroskaFileSeeker {
	private static long UNIX_EPOCH_DELAY = 978307200;

	private final SeekableByteChannel channel;

	private final ByteBuffer idBuffer;

	private final ByteBuffer sizeBuffer;

	public MatroskaFileSeeker(Path path) throws IOException {
		channel = Files.newByteChannel(path, StandardOpenOption.READ);

		idBuffer = ByteBuffer.allocateDirect(8);
		sizeBuffer = ByteBuffer.allocateDirect(8);
	}

	public EbmlElement nextElement() throws IOException {
		// read element id
		byte[] id = toArray(readElementId());

		// read element data size
		byte[] dataSize = toArray(readDataSize());

		return createElement(id, dataSize);
	}

	private static EbmlElement createElement(byte[] id, byte[] dataSize) {
		int headerSize = id.length + dataSize.length;
		long size = bytesToLong(dataSize);
		MatroskaNode node = MatroskaNode.get(id);

		EbmlElement element;
		if (node == null) {
			element = new EbmlUnknownElement(id, headerSize, size);
		} else if (EbmlElementType.MASTER.equals(node.getType())) {
			element = new EbmlMasterElement(node, headerSize, size);
		} else {
			element = new EbmlDataElement(node, headerSize, size);
		}

		return element;
	}

	private ByteBuffer readElementId() throws IOException {
		idBuffer.clear();

		// read leading bit
		idBuffer.limit(1);
		if (channel.read(idBuffer) != 1) {
			throw new RuntimeException();
		}

		// convert length
		final int length = getLength(idBuffer.get(0));

		// read rest of id
		idBuffer.limit(length);
		if (channel.read(idBuffer) != length - 1) {
			throw new RuntimeException();
		}

		idBuffer.flip();

		return idBuffer;
	}

	private ByteBuffer readDataSize() throws IOException {
		sizeBuffer.clear();

		// read leading bit
		sizeBuffer.limit(1);
		if (channel.read(sizeBuffer) != 1) {
			throw new RuntimeException();
		}

		// convert length
		final int length = getLength(sizeBuffer.get(0));

		// read rest of id
		sizeBuffer.limit(length);
		if (channel.read(sizeBuffer) != length - 1) {
			throw new RuntimeException();
		}

		// clear the first byte
		sizeBuffer.put(0, (byte) (sizeBuffer.get(0) & ((0xFF >>> length))));

		sizeBuffer.flip();

		return sizeBuffer;
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

	public EbmlElement nextChild(EbmlMasterElement parent) throws IOException {
		if (!parent.hasNext()) {
			return null;
		}

		EbmlElement element = nextElement();
		if (element == null) {
			return null;
		}

		parent.add(element);

		return element;
	}

	public long getPosition() throws IOException {
		return channel.position();
	}

	public void dispose() throws IOException {
		channel.close();
	}

	private long skip(long offset) throws IOException {
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

		return newpos - pos;
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

	public static byte[] toArray(ByteBuffer buffer) {
		byte[] arr = new byte[buffer.limit()];
		buffer.get(arr);

		return arr;
	}

	public void skip(EbmlElement element) throws IOException {
		skip(element.getSkipSize());
	}

	public byte[] readBytes(EbmlDataElement element) throws IOException {
		if (!element.read()) {
			readData(element);
		}

		return element.getData();
	}

	public double readDouble(EbmlDataElement element) throws IOException {
		readBytes(element);

		if (EbmlElementType.FLOAT.equals(element.getType())) {
			if (element.getSize() == 4) {
				float value = 0;
				ByteArrayInputStream bIS = new ByteArrayInputStream(element.getData());
				DataInputStream dIS = new DataInputStream(bIS);
				value = dIS.readFloat();
				return value;

			} else if (element.getSize() == 8) {
				double value = 0;
				ByteArrayInputStream bIS = new ByteArrayInputStream(element.getData());
				DataInputStream dIS = new DataInputStream(bIS);
				value = dIS.readDouble();
				return value;
			}
		}

		throw new RuntimeException();
	}

	public long readInteger(EbmlDataElement element) throws IOException {
		readBytes(element);

		switch (element.getType()) {
		case UINTEGER:
			return uintToLong(element.getData());
		default:
			throw new RuntimeException();
		}
	}

	private long uintToLong(byte[] data) {
		long l = 0;
		long tmp = 0;
		for (int i = 0; i < data.length; i++) {
			tmp = ((long) data[data.length - 1 - i]) << 56;
			tmp >>>= (56 - (i * 8));
			l |= tmp;
		}
		return l;
	}

	public String readString(EbmlDataElement element) throws IOException {
		readBytes(element);

		if (EbmlElementType.ASCII.equals(element.getType())) {
			return new String(element.getData(), Charsets.US_ASCII);
		} else if (EbmlElementType.STRING.equals(element.getType())) {
			return new String(element.getData(), Charsets.UTF_8);
		}

		throw new RuntimeException();
	}

	private void readData(EbmlDataElement element) throws IOException {
		ByteBuffer buffer = ByteBuffer.allocateDirect((int) element.getSize());

		channel.read(buffer);

		buffer.flip();

		element.setData(toArray(buffer));

		if (element.getSize() > Integer.MAX_VALUE) {
			throw new RuntimeException();
		}
	}

	public long readTimestamp(EbmlDataElement element) throws IOException {
		readBytes(element);

		byte[] data = element.getData();

		long l = 0;
		long tmp = 0;
		l |= ((long) data[0] << (56 - ((8 - data.length) * 8)));
		for (int i = 1; i < data.length; i++) {
			tmp = ((long) data[data.length - i]) << 56;
			tmp >>>= 56 - (8 * (i - 1));
			l |= tmp;
		}

		l /= 1000000000;
		l += UNIX_EPOCH_DELAY;

		return l * 1000;
	}

	public EbmlElement nextElement(long position) throws IOException {
		channel.position(position);
		return nextElement();
	}
}
