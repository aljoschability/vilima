package com.aljoschability.vilima.reading.elements;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public class FloatElement extends BinaryElement {
	public FloatElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	/**
	 * Get the float value of this element
	 * 
	 * @return Float value of this element
	 * @throws ArithmeticException for 80-bit or 10-byte floats. AFAIK Java doesn't support them
	 */
	public double getValue() {
		try {
			if (getSize() == 4) {
				float value = 0;
				ByteArrayInputStream bIS = new ByteArrayInputStream(getData());
				DataInputStream dIS = new DataInputStream(bIS);
				value = dIS.readFloat();
				return value;

			} else if (getSize() == 8) {
				double value = 0;
				ByteArrayInputStream bIS = new ByteArrayInputStream(getData());
				DataInputStream dIS = new DataInputStream(bIS);
				value = dIS.readDouble();
				return value;

			} else {
				throw new ArithmeticException("80-bit floats are not supported");
			}
		} catch (IOException ex) {
			return 0;
		}
	}

	public double readDouble(MatroskaEventReader reader) throws IOException {
		readData(reader);

		return getValue();
	}
}
