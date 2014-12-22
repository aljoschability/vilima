package com.aljoschability.vilima.reading

import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator
import com.google.common.base.Charsets

class MatroskaFileReaderHelper {
	val static public INSTANCE = new MatroskaFileReaderHelper

	def long asLong(byte[] data) {

		// TODO: use extension method here
		return MkResourceReaderByteOperator::INSTANCE.bytesToLongUnsigned(data)
	}

	def long asLong(EbmlDataElement element) {
		if(element.node.type == EbmlElementType::UINTEGER) {
			return element.data.asLong
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

	def boolean asBoolean(EbmlDataElement element) {
		element.asLong == 1
	}

	def int asInteger(byte[] data) {
		data.asLong as int
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
		switch element.node.type {
			case ASCII:
				return new String(element.data, Charsets::US_ASCII)
			case STRING:
				return new String(element.data, Charsets::UTF_8)
			default: {
			}
		}
	}

	def byte[] asBytes(EbmlDataElement element) {
		element.data
	}

	def Long asTimestamp(EbmlDataElement element) {

		// TODO: use extension method here
		MkResourceReaderByteOperator::INSTANCE.readTimestamp(element.data)
	}

	def String asHex(EbmlDataElement element) {

		// TODO: use extension method here
		MkResourceReaderByteOperator::INSTANCE.bytesToHex(element.data)
	}
}
