package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.extensions.impl.MatroskaFileReaderByteOperator
import com.aljoschability.vilima.reading.EbmlDataElement
import com.aljoschability.vilima.reading.EbmlElementType
import com.google.common.base.Charsets

class MatroskaFileReaderExtension {
	val static public INSTANCE = new MatroskaFileReaderExtension

	def byte[] asBytes(EbmlDataElement element) {
		element.data
	}

	def boolean asBoolean(EbmlDataElement element) {
		element.asLong == 1
	}

	def long asLong(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::UINTEGER) {
			return element.data.asLong
		}

		if(element.node.type == EbmlElementType::INTEGER) {
			return element.data.asLongSigned
		}

		throw new RuntimeException
	}

	def double asDouble(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::FLOAT) {
			if(element.size == 4) {
				return Float::intBitsToFloat(element.data.asInteger)
			}

			if(element.size == 8) {
				return Double::longBitsToDouble(element.data.asLong)
			}
		}

		throw new RuntimeException
	}

	def String asString(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::STRING) {
			return element.data.asStringUnicode
		}

		if(element.node.type == EbmlElementType::ASCII) {
			return element.data.asStringAscii
		}

		throw new RuntimeException
	}

	def MkTrackType asMkTrackType(EbmlDataElement element) {
		switch element.data.asInteger {
			case 0x01: MkTrackType::VIDEO
			case 0x02: MkTrackType::AUDIO
			case 0x03: MkTrackType::COMPLEX
			case 0x10: MkTrackType::LOGO
			case 0x11: MkTrackType::SUBTITLE
			case 0x20: MkTrackType::CONTROL
			default: throw new RuntimeException("could not convert track type")
		}
	}

	def Long asTimestamp(EbmlDataElement element) {
		MatroskaFileReaderByteOperator::readTimestamp(element.data)
	}

	def String asHex(EbmlDataElement element) {
		MatroskaFileReaderByteOperator::bytesToHex(element.data)
	}

	def private int asInteger(byte[] data) {
		data.asLong as int
	}

	def private long asLongSigned(byte[] data) {
		MatroskaFileReaderByteOperator::bytesToLong(data)
	}

	def private long asLong(byte[] data) {
		MatroskaFileReaderByteOperator::bytesToLongUnsigned(data)
	}

	def private String asStringAscii(byte[] data) {
		return new String(data, Charsets::US_ASCII)
	}

	def private String asStringUnicode(byte[] data) {
		return new String(data, Charsets::UTF_8)
	}
}
