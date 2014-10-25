package com.aljoschability.vilima.helpers;

import com.aljoschability.vilima.MkTrackType;

public class MkReaderByter {
	private static char[] HEX = "0123456789ABCDEF".toCharArray();

	public static String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = HEX[v >>> 4];
			hexChars[j * 2 + 1] = HEX[v & 0x0F];
		}
		return new String(hexChars);
	}

	public static MkTrackType convertTrackType(byte value) {
		switch (value) {
		case 0x01:
			return MkTrackType.VIDEO;
		case 0x02:
			return MkTrackType.AUDIO;
		case 0x03:
			return MkTrackType.COMPLEX;
		case 0x10:
			return MkTrackType.LOGO;
		case 0x11:
			return MkTrackType.SUBTITLE;
		case 0x20:
			return MkTrackType.CONTROL;
		default:
			throw new RuntimeException("cannot convert track type from " + value);
		}
	}
}
