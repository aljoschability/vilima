package com.aljoschability.vilima.nio;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SeekableByteChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class Parser {
	private SeekableByteChannel channel;

	public void parse(Path path) throws IOException {
		channel = Files.newByteChannel(path, StandardOpenOption.READ);

		byte[] id = readIdentifier();

		channel.close();
	}

	private byte[] readIdentifier() throws IOException {
		ByteBuffer firstByte = ByteBuffer.allocateDirect(1);
		int firstByteRead = channel.read(firstByte);
		byte firstByteByte = firstByte.get(0);

		int numBytes = getIndexOfFirst(firstByteByte);

		// setup space to store the bits
		ByteBuffer data = ByteBuffer.allocateDirect(numBytes);
		data.put(0, firstByteByte);

		// read the rest of the size
		channel.read(data);

		return null;
	}

	private int getIndexOfFirst(byte value) {
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
}
