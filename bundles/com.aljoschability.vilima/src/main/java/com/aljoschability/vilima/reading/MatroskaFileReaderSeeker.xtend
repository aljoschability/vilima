package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.extensions.MatroskaFileReaderExtension
import com.aljoschability.vilima.extensions.impl.MatroskaFileReaderByteOperator
import java.io.IOException
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
	extension MatroskaFileReaderExtension = MatroskaFileReaderExtension::INSTANCE

	val ByteBuffer bufferHead = ByteBuffer::allocateDirect(8)
	val ByteBuffer bufferSize = ByteBuffer::allocateDirect(8)

	SeekableByteChannel channel

	long offset
	Queue<Long> seeks
	Collection<Long> positionsParsed

	new(Path path) {
		seeks = new LinkedList
		positionsParsed = newArrayList
		offset = -1

		if(channel != null) {
			println('''the channel has not been closed!''')
			channel.close
		}

		channel = Files::newByteChannel(path, StandardOpenOption::READ)
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

				element.data = toArray(buffer)

				if(element.size > Integer::MAX_VALUE) {
					throw new RuntimeException()
				}
			}
			return element
		}
	}

	def void dispose() {
		channel?.close()
		channel = null

		seeks = null
		positionsParsed = null
		offset = -1
	}

	def private EbmlElement nextElement() {
		val id = readElementId()
		val dataSize = readDataSize()

		val node = MatroskaNode.get(id)

		var EbmlElement element = null
		if(node == null) {
			println(
				'''unknown EBML element created: id=«Arrays::toString(id)»; hex=«MatroskaFileReaderByteOperator::
					bytesToHex(id)»''')
			element = new EbmlUnknownElement(id, dataSize)
		} else if(EbmlElementType::MASTER == node.type) {
			element = new EbmlMasterElement(id, dataSize);
		} else {
			element = new EbmlDataElement(id, dataSize);
		}

		return element
	}

	def private byte[] readElementId() {
		bufferHead.clear()

		// read leading bit
		bufferHead.limit(1)
		if(channel.read(bufferHead) != 1) {
			throw new RuntimeException()
		}

		// convert length
		val length = MatroskaFileReaderByteOperator::getLength(bufferHead.get(0))

		// read rest of id
		bufferHead.limit(length)
		if(channel.read(bufferHead) != length - 1) {
			throw new RuntimeException()
		}

		bufferHead.flip()

		return toArray(bufferHead)
	}

	def private byte[] readDataSize() {
		bufferSize.clear()

		// read leading bit
		bufferSize.limit(1)
		if(channel.read(bufferSize) != 1) {
			throw new RuntimeException()
		}

		// convert length
		val length = MatroskaFileReaderByteOperator::getLength(bufferSize.get(0))

		// read rest of id
		bufferSize.limit(length)
		if(channel.read(bufferSize) != length - 1) {
			throw new RuntimeException()
		}

		// clear the first byte
		MatroskaFileReaderByteOperator::clearFirstByte(bufferSize, length)

		bufferSize.flip()

		return toArray(bufferSize)
	}

	/*****************************************/
	/*****************************************/
	def private static byte[] toArray(ByteBuffer buffer) {
		val result = newByteArrayOfSize(buffer.limit)
		buffer.get(result)
		return result
	}

	MatroskaFileBuilder builder

	def private long getPosition() {
		return channel.position()
	}

	def private EbmlElement nextElement(long position) throws IOException {
		channel.position(position);
		return nextElement();
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

		this.offset = position

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
					addPositionsParsed(position - element.headerSize)
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
