package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.extensions.MatroskaFileReaderExtension
import java.nio.ByteBuffer
import java.nio.channels.SeekableByteChannel
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardOpenOption
import java.util.Arrays
import java.util.Collection
import java.util.LinkedList
import java.util.Queue

class MatroskaFileSeeker {
	val static RESERVED_ELEMENT = new EbmlElement(null, 0, 0) {
		override getSkipLength() { 0 }
	}

	extension MatroskaFileReaderSeekerExtension = new MatroskaFileReaderSeekerExtension
	extension MatroskaFileReaderExtension = MatroskaFileReaderExtension::INSTANCE

	val ByteBuffer headerBuffer
	val SeekableByteChannel channel

	val Queue<Long> seeks
	val Collection<Long> positionsParsed

	long offset

	MatroskaFileBuilder builder

	new(Path path) {
		headerBuffer = ByteBuffer::allocateDirect(8)

		channel = Files::newByteChannel(path, StandardOpenOption::READ)

		seeks = new LinkedList
		positionsParsed = newArrayList
	}

	/**
 	 * Skips the rest of given element.
 	 */
	def void skip(EbmlElement element) {
		var position = channel.position + element.skipLength

		// do not jump out of the file
		val limit = channel.size
		if(position > limit) {
			position = limit
		}

		channel.position(position)
	}

	def boolean hasNext(EbmlElement parent) {
		if(parent instanceof EbmlMasterElement) {
			return parent.hasNext
		}
		return false
	}

	def EbmlElement nextChild(EbmlElement parent) {
		if(parent instanceof EbmlMasterElement) {
			return parent.addChild(nextElement)
		}
	}

	def EbmlDataElement getData(EbmlElement element) {
		if(element instanceof EbmlDataElement) {
			if(element.data == null) {
				val buffer = ByteBuffer.allocateDirect(element.size as int)

				channel.read(buffer)

				buffer.flip()

				element.data = buffer.toArray
			}
			return element
		}
	}

	def void dispose() {
		channel.close()
	}

	/**
	 * Rewinds the buffer, reads the first byte, encode its length and reads the rest.
	 * 
	 * @return Returns the length.
	 */
	def private void fillBuffer(ByteBuffer buffer) {

		// read first byte
		buffer.rewind()
		buffer.limit(1)
		channel.read(buffer)

		// read rest
		buffer.limit(buffer.get(0).length)
		channel.read(buffer)
	}

	def private byte[] readElementId() {
		headerBuffer.fillBuffer

		headerBuffer.flip()

		return headerBuffer.toArray
	}

	def private byte[] readDataSize() {
		headerBuffer.fillBuffer

		// clear the first byte
		headerBuffer.clearFirstByte()

		headerBuffer.flip()

		return headerBuffer.toArray
	}

	def private EbmlElement nextElement() {

		// read element id and catch its node
		val id = readElementId()
		val node = MatroskaNode.get(id)
		if(node == null) {
			return RESERVED_ELEMENT
		}

		// read element size
		val sizeData = readDataSize()
		val size = MatroskaFileReaderExtension.asLong(sizeData)
		val headerSize = id.length + sizeData.length

		if(EbmlElementType::MASTER == node.type) {
			return new EbmlMasterElement(node, headerSize, size);
		} else {
			return new EbmlDataElement(node, headerSize, size);
		}
	}

	def private EbmlElement nextElement(long position) {
		channel.position(position)
		return nextElement()
	}

	def private boolean hasSeeks() {
		seeks -= positionsParsed

		return !seeks.empty
	}

	def private void addPositionsParsed(long position) {
		positionsParsed += position
		seeks.remove(position)
	}

	def private EbmlElement getSegmentElement() {
		skipEbmlHeader()

		val parent = nextElement()

		if(parent.node != MatroskaNode::Segment) {
			throw new RuntimeException("Segment not the second element in the file.")
		}

		this.offset = channel.position()

		return parent
	}

	def private void skipEbmlHeader() {
		val parent = nextElement

		if(parent.node != MatroskaNode::EBML) {
			throw new RuntimeException("EBML root element could not be read.")
		}

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case DocType: {
					val value = element.data.asString
					if(value != "matroska" && value != "webm") {
						throw new RuntimeException("EBML document type cannot be read.")
					}
				}
				default: {
				}
			}
			element.skip
		}
	}

	def void readFile(MatroskaFileBuilder builder) {
		this.builder = builder
		segmentElement.parseSegment

		readSeeks()
	}

	def private void parseSegment(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case SeekHead: {
					element.handleSeekHead
				}
				case Cluster: {
					return
				}
				default: {
					addPositionsParsed(channel.position() - element.headerSize)
					builder.readSegmentNode(element)
				}
			}

			element.skip
		}
	}

	def private void readSeeks() {
		while(hasSeeks) {
			val element = nextElement(seeks.poll)
			builder.readSegmentNode(element)
		}
	}

	def private void parseSeek(EbmlElement parent) {
		var byte[] id = null
		var long position = -1

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case SeekID: {
					id = element.data.asBytes
				}
				case SeekPosition: {
					position = element.data.asLong
				}
				default: {
				}
			}

			element.skip
		}

		// ignore cluster
		if(!Arrays::equals(MatroskaNode::Cluster.id, id)) {
			seeks.offer(position + offset)
		}
	}

	/* Called when a <code>SeekHead</code> element appears. */
	def private void handleSeekHead(EbmlElement parent) {
		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case Seek: {
					element.parseSeek
				}
				default: {
				}
			}

			element.skip
		}
	}
}

class MatroskaFileReaderSeekerExtension {
	def int getLength(byte value) {
		var int mask = 0x0080
		for (var int length = 0; length < 8; length++) {
			if(value.bitwiseAnd(mask) == mask) {
				return length + 1
			}
			mask = mask >>> 1
		}

		throw new RuntimeException
	}

	def void clearFirstByte(ByteBuffer buffer) {
		buffer.put(0, buffer.get(0).bitwiseAnd(0xFF >>> buffer.limit).byteValue)
	}

	def byte[] toArray(ByteBuffer buffer) {
		val result = newByteArrayOfSize(buffer.limit)
		buffer.get(result)
		return result
	}
}
