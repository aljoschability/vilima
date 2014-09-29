package com.aljoschability.vilima.reading.elements;

import java.util.Arrays;

public class SimpleBlockElement extends BinaryElement {
	private int[] sizes = null;
	private int headerSize = 0;
	private int blockTimecode = 0;
	private int trackNumber = 0;
	private boolean isKeyframe;

	public SimpleBlockElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	private static int _UTIL__codedSizeLength(long value) {
		int codedSize = 0;
		if (value < 127) {
			codedSize = 1;
		} else if (value < 16383) {
			codedSize = 2;
		} else if (value < 2097151) {
			codedSize = 3;
		} else if (value < 268435455) {
			codedSize = 4;
		}
		return codedSize;
	}

	/**
	 * Reads an (Unsigned) EBML code from the DataSource and encodes it into a long. This size
	 * should be cast into an int for actual use as Java only allows upto 32-bit file I/O
	 * operations.
	 *
	 * @return ebml size
	 */
	private static long _UTIL_readEBMLCode(byte[] source, int offset) {
		// Begin loop with byte set to newly read byte.
		byte firstByte = source[offset];
		int numBytes = 0;

		// Begin by counting the bits unset before the first '1'.
		long mask = 0x0080;
		for (int i = 0; i < 8; i++) {
			// Start at left, shift to right.
			if ((firstByte & mask) == mask) { // One found
												// Set number of bytes in size = i+1 ( we must count
												// the 1 too)
				numBytes = i + 1;
				// exit loop by pushing i out of the limit
				i = 8;
			}
			mask >>>= 1;
		}
		if (numBytes == 0)
			// Invalid size
			return 0;

		// Setup space to store the bits
		byte[] data = new byte[numBytes];

		// Clear the 1 at the front of this byte, all the way to the beginning of the size
		data[0] = (byte) (firstByte & ((0xFF >>> (numBytes))));

		if (numBytes > 1) {
			// Read the rest of the size.
			System.arraycopy(data, 1, source, offset + 1, numBytes - 1);
		}

		// Put this into a long
		long size = 0;
		long n = 0;
		for (int i = 0; i < numBytes; i++) {
			n = ((long) data[numBytes - 1 - i] << 56) >>> 56;
			size = size | (n << (8 * i));
		}
		return size;
	}

	public void parseBlock() {
		byte[] data = getData();

		int index = 0;
		trackNumber = (int) _UTIL_readEBMLCode(data, 0);
		index = _UTIL__codedSizeLength(trackNumber);
		headerSize += index;

		short blockTimecode1 = (short) (data[index++] & 0xFF);
		short blockTimecode2 = (short) (data[index++] & 0xFF);
		if (blockTimecode1 != 0 || blockTimecode2 != 0) {
			blockTimecode = (blockTimecode1 << 8) | blockTimecode2;
		}

		int flagKeyframe = data[index] & 0x80;
		this.isKeyframe = flagKeyframe > 0;

		int flagLacing = data[index] & 0x06;
		index++;

		// Increase the HeaderSize by the number of bytes we have read
		headerSize += 3;

		if (flagLacing != 0x00) {
			// We have lacing
			byte LaceCount = data[index++];
			headerSize += 1;
			if (flagLacing == 0x02) {
				// Xiph Lacing
				sizes = readXiphLaceSizes(index, LaceCount);

			} else if (flagLacing == 0x06) {
				// EBML Lacing
				sizes = readEBMLLaceSizes(index, LaceCount);

			} else if (flagLacing == 0x04) {
				// Fixed Size Lacing
				sizes = new int[LaceCount + 1];
				sizes[0] = (int) (this.getSize() - headerSize) / (LaceCount + 1);
				for (int s = 0; s < LaceCount; s++) {
					sizes[s + 1] = sizes[0];
				}
			} else {
				throw new RuntimeException("Unsupported lacing type flag.");
			}
		}
		// data = new byte[(int)(this.getSize() - HeaderSize)];
		// source.read(data, 0, data.length);
		// this.dataRead = true;
	}

	/**
	 * Reads an Signed EBML code from the DataSource and encodes it into a long. This size should be
	 * cast into an int for actual use as Java only allows upto 32-bit file I/O operations.
	 *
	 * @return ebml size
	 */
	private static long _UTIL_readSignedEBMLCode(byte[] source, int offset) {
		// Begin loop with byte set to newly read byte.
		byte firstByte = source[offset];
		int numBytes = 0;

		// Begin by counting the bits unset before the first '1'.
		long mask = 0x0080;
		for (int i = 0; i < 8; i++) {
			// Start at left, shift to right.
			if ((firstByte & mask) == mask) { // One found
												// Set number of bytes in size = i+1 ( we must count
												// the 1 too)
				numBytes = i + 1;
				// exit loop by pushing i out of the limit
				i = 8;
			}
			mask >>>= 1;
		}
		if (numBytes == 0)
			// Invalid size
			return 0;

		// Setup space to store the bits
		byte[] data = new byte[numBytes];

		// Clear the 1 at the front of this byte, all the way to the beginning of the size
		data[0] = (byte) (firstByte & ((0xFF >>> (numBytes))));

		if (numBytes > 1) {
			// Read the rest of the size.
			System.arraycopy(data, 1, source, offset + 1, numBytes - 1);
		}

		// Put this into a long
		long size = 0;
		long n = 0;
		for (int i = 0; i < numBytes; i++) {
			n = ((long) data[numBytes - 1 - i] << 56) >>> 56;
			size = size | (n << (8 * i));
		}

		// Sign it ;)
		if (numBytes == 1) {
			size -= 63;

		} else if (numBytes == 2) {
			size -= 8191;

		} else if (numBytes == 3) {
			size -= 1048575;

		} else if (numBytes == 4) {
			size -= 134217727;
		}

		return size;
	}

	private int[] readEBMLLaceSizes(int index, short laceCount) {
		byte[] data = getData();

		int[] laceSizes = new int[laceCount + 1];
		laceSizes[laceCount] = (int) this.getSize();

		// This uses the DataSource.getBytePosition() for finding the header size
		// because of the trouble of finding the byte size of sized ebml coded integers
		// long ByteStartPos = source.getFilePointer();
		int startIndex = index;

		laceSizes[0] = (int) _UTIL_readEBMLCode(data, index);
		index += _UTIL__codedSizeLength(laceSizes[0]);
		laceSizes[laceCount] -= laceSizes[0];

		long firstEBMLSize = laceSizes[0];
		long lastEBMLSize = 0;
		for (int l = 0; l < laceCount - 1; l++) {
			lastEBMLSize = _UTIL_readSignedEBMLCode(data, index);
			index += _UTIL__codedSizeLength(lastEBMLSize);

			firstEBMLSize += lastEBMLSize;
			laceSizes[l + 1] = (int) firstEBMLSize;

			// Update the size of the last block
			laceSizes[laceCount] -= laceSizes[l + 1];
		}
		// long ByteEndPos = source.getFilePointer();

		// HeaderSize = HeaderSize + (int)(ByteEndPos - ByteStartPos);
		headerSize = headerSize + (int) (index - startIndex);
		laceSizes[laceCount] -= headerSize;

		return laceSizes;
	}

	private int[] readXiphLaceSizes(int index, short laceCount) {
		byte[] data = getData();

		int[] laceSizes = new int[laceCount + 1];
		laceSizes[laceCount] = (int) this.getSize();

		// long ByteStartPos = source.getFilePointer();

		for (int l = 0; l < laceCount; l++) {
			short laceSizeByte = 255;
			while (laceSizeByte == 255) {
				laceSizeByte = (short) (data[index++] & 0xFF);
				headerSize += 1;
				laceSizes[l] += laceSizeByte;
			}
			// Update the size of the last block
			laceSizes[laceCount] -= laceSizes[l];
		}
		// long ByteEndPos = source.getFilePointer();

		laceSizes[laceCount] -= headerSize;

		return laceSizes;
	}

	public int getFrameCount() {
		if (sizes == null) {
			return 1;
		}
		return sizes.length;
	}

	public byte[] getFrame(int frame) {
		byte[] data = getData();

		if (sizes == null) {
			if (frame != 0) {
				throw new IllegalArgumentException("Tried to read laced frame on non-laced Block (frame != 0).");
			}
			byte[] frameData = new byte[data.length - headerSize];
			System.arraycopy(data, headerSize, frameData, 0, frameData.length);

			return frameData;
		}
		if (sizes[frame] < 0) {
			System.out.println("problem -- did not understand the specs...");

			System.out.println("frame=" + frame);
			System.out.println("sizes[]=" + Arrays.toString(sizes));

			// byte[] frameData = new byte[data.length - headerSize];
			// System.arraycopy(data, headerSize, frameData, 0, frameData.length);

			// return frameData;
		}

		byte[] frameData = new byte[sizes[frame]];

		// Calc the frame data offset
		int startOffset = headerSize;
		for (int s = 0; s < frame; s++) {
			startOffset += sizes[s];
		}

		// Copy the frame data
		System.arraycopy(data, startOffset, frameData, 0, frameData.length);

		return frameData;
	}

	public long getAdjustedBlockTimecode(long clusterTimecode, long timecodeScale) {
		return clusterTimecode + (blockTimecode);// * TimecodeScale);
	}

	public int getTrackNumber() {
		return trackNumber;
	}

	public boolean isKeyframe() {
		return isKeyframe;
	}
}
