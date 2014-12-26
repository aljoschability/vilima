package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.reading.EbmlDataElement
import com.aljoschability.vilima.reading.EbmlElementType
import com.google.common.base.Charsets
import com.google.common.primitives.UnsignedLong
import java.nio.ByteBuffer
import java.util.concurrent.TimeUnit

class MatroskaFileReaderExtension {
	val static public INSTANCE = new MatroskaFileReaderExtension

	val static HEX = "0123456789ABCDEF".toCharArray

	def byte[] asBytes(EbmlDataElement element) {
		element.data
	}

	def boolean asBoolean(EbmlDataElement element) {
		val value = element.asLong

		if(value == 0) {
			return false
		}

		if(value == 1) {
			return true
		}

		throw new RuntimeException
	}

	def long asLong(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::UINTEGER) {
			return element.data.asLong
		}

		if(element.node.type == EbmlElementType::INTEGER) {
			return element.data.asSignedLong
		}

		throw new RuntimeException
	}

	def double asDouble(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::FLOAT) {
			if(element.size == 4) {
				return Float::intBitsToFloat(element.data.asLong as int)
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
		switch element.data.asLong as int {
			case 0x01: MkTrackType::VIDEO
			case 0x02: MkTrackType::AUDIO
			case 0x03: MkTrackType::COMPLEX
			case 0x10: MkTrackType::LOGO
			case 0x11: MkTrackType::SUBTITLE
			case 0x20: MkTrackType::CONTROL
			default: throw new RuntimeException("could not convert track type")
		}
	}

	def long asTimestamp(EbmlDataElement element) {
		var result = ByteBuffer::wrap(element.data).getLong
		result = TimeUnit::NANOSECONDS.toMillis(result)
		result += 978307200000l
		return result
	}

	public static def long asLong(byte[] data) {
		val buffer = ByteBuffer::allocate(8)

		// position
		buffer.position(8 - data.length)

		// put data
		buffer.put(data)

		// rewind and get value
		buffer.rewind()

		// warn at least when long overflowed
		val result = buffer.long
		if(result < 0) {
			val exp = UnsignedLong::fromLongBits(result).bigIntegerValue
			println('''could not convert unsigned integer to long: «exp» expected, returned «result» instead.''')
		}

		return result
	}

	def String asHex(EbmlDataElement element) {
		val bytes = element.data
		val hexChars = newCharArrayOfSize(bytes.length * 2)
		for (var int j = 0; j < bytes.length; j++) {
			val v = bytes.get(j).bitwiseAnd(0xFF)
			hexChars.set(j * 2, HEX.get(v >>> 4))
			hexChars.set(j * 2 + 1, HEX.get(v.bitwiseAnd(0x0F)))
		}
		return new String(hexChars)
	}

	def private long asSignedLong(byte[] data) {
		var long size = 0
		var long value = 0
		for (var i = 0; i < data.length; i++) {
			value = (data.get(data.length - 1 - i) << 56) >>> 56
			size = size.bitwiseOr(value << (8 * i))
		}
		return size
	}

	def private String asStringAscii(byte[] data) {
		return new String(data, Charsets::US_ASCII)
	}

	def private String asStringUnicode(byte[] data) {
		return new String(data, Charsets::UTF_8)
	}
}
