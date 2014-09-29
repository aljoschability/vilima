package com.aljoschability.vilima.reading.elements;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import com.aljoschability.vilima.reading.MatroskaEventReader;
import com.google.common.base.Charsets;

/**
 * Baisc class for handling an EBML string data type. This class encapsulates both UTF and ASCII
 * string types and can use any string type supported by the Java platform.
 *
 * @author John Cannon
 */
public class StringElement extends BinaryElement {
	private String charset = "UTF-8";

	/** Creates a new instance of StringElement */
	public StringElement(byte[] id, int headerSize, long size) {
		this(id, headerSize, size, Charsets.UTF_8.name());
	}

	public StringElement(byte[] id, int headerSize, long size, String encoding) {
		super(id, headerSize, size);
		charset = encoding;
	}

	private boolean checkForCharsetHack() {
		// Check if we are trying to read UTF-8, if so lets try UTF8.
		// Microsofts Java supports "UTF8" but not "UTF-8"
		if (charset.compareTo("UTF-8") == 0) {
			charset = "UTF8";
			// Let's try again
			return true;
		} else if (charset.compareTo("US-ASCII") == 0) {
			// This is the same story as UTF-8,
			// If Microsoft is going to hijack Java they should at least support the orignal :>
			charset = "ASCII";
			// Let's try again
			return true;
		}
		return false;
	}

	public String getValue() {
		try {
			return new String(getData(), charset);
		} catch (UnsupportedEncodingException ex) {
			if (checkForCharsetHack()) {
				return getValue();
			}
			ex.printStackTrace();
			return "";
		}
	}

	public String getEncoding() {
		return charset;
	}

	public String readString(MatroskaEventReader reader) throws IOException {
		readData(reader);

		return getValue();
	}
}
