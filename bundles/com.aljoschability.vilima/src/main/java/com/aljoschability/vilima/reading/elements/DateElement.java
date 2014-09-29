package com.aljoschability.vilima.reading.elements;

import java.io.IOException;
import java.util.Date;

import com.aljoschability.vilima.reading.MatroskaEventReader;

public class DateElement extends SignedIntegerElement {
	private static long UnixEpochDelay = 978307200; // 2001/01/01 00:00:00 UTC

	public DateElement(byte[] id, int headerSize, long size) {
		super(id, headerSize, size);
	}

	public Date getDate() {
		long val = getValue();

		val /= 1000000000;
		val += UnixEpochDelay;

		return new Date(val * 1000);
	}

	public long readTimestamp(MatroskaEventReader reader) throws IOException {
		readData(reader);

		long val = getValue();

		val /= 1000000000;
		val += UnixEpochDelay;

		return val * 1000;
	}
}
