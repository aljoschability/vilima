package com.aljoschability.vilima.reading;

import java.util.Arrays

class EbmlUnknownElement extends EbmlElement {
	new(byte[] id, int headerSize, long size) {
		super(id, EbmlElementType::UNKNOWN, headerSize, size)

		println(
			'''unknown EBML element created: id=«Arrays.toString(id)»; hex=«MkFileReaderSeekerExtension::bytesToHex(id)»''')
	}

	override getSkipSize() { 0 }
}
