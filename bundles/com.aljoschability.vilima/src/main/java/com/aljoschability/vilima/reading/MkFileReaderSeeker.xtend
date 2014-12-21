package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator
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
	val ByteBuffer bufferHead = ByteBuffer::allocateDirect(8)
	val ByteBuffer bufferSize = ByteBuffer::allocateDirect(8)

	SeekableByteChannel channel

	long offset
	Queue<Long> seeks
	public Collection<Long> positionsParsed

	def void skip(EbmlElement element) {
		val pos = channel.position
		val len = channel.size
		var newpos = pos + element.skipSize
		if(newpos > len) {
			newpos = len
		}
		channel.position(newpos)
	}

	def private byte[] readElementId() {
		bufferHead.clear()

		// read leading bit
		bufferHead.limit(1)
		if(channel.read(bufferHead) != 1) {
			throw new RuntimeException()
		}

		// convert length
		val length = getLength(bufferHead.get(0))

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
		val length = getLength(bufferSize.get(0))

		// read rest of id
		bufferSize.limit(length)
		if(channel.read(bufferSize) != length - 1) {
			throw new RuntimeException()
		}

		// clear the first byte
		clearFirstByte(bufferSize, length)

		bufferSize.flip()

		return toArray(bufferSize)
	}

	def EbmlElement nextElement() {
		val id = readElementId()
		val dataSize = readDataSize()

		val node = MatroskaNode.get(id)

		if(node == null) {
			println('''unknown EBML element created: id=«Arrays::toString(id)»; hex=«bytesToHex(id)»''')
			return new EbmlUnknownElement(id, dataSize)
		} else if(EbmlElementType::MASTER == node.type) {
			return new EbmlMasterElement(id, dataSize);
		} else {
			return new EbmlDataElement(id, dataSize);
		}
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

	def void initialize(Path path) {
		seeks = new LinkedList
		positionsParsed = newArrayList
		offset = -1

		if(channel != null) {
			println('''the channel has not been closed!''')
			channel.close
		}

		channel = Files::newByteChannel(path, StandardOpenOption::READ)
	}

	def void dispose() {
		channel?.close()
		channel = null

		seeks = null
		positionsParsed = null
		offset = -1
	}

	/*****************************************/
	/*****************************************/
	@Deprecated
	def long offset(EbmlElement element) {
		return position - element.headerSize
	}

	@Deprecated
	def private static byte[] toArray(ByteBuffer buffer) {
		val result = newByteArrayOfSize(buffer.limit)
		buffer.get(result)
		return result
	}

	extension MkResourceReaderByteOperator = MkResourceReaderByteOperator::INSTANCE

	@Deprecated
	def long getPosition() {
		return channel.position()
	}

	/********************************************/
	@Deprecated
	def EbmlElement nextElement(long position) throws IOException {
		channel.position(position);
		return nextElement();
	}

	/********************************************/
	@Deprecated
	def boolean hasSeeks() {
		seeks -= positionsParsed

		return !seeks.empty
	}

	@Deprecated
	def long nextSeekPosition() {
		seeks.poll
	}

	@Deprecated
	def offer(long position) {
		seeks.offer(position + offset)
	}

	@Deprecated
	def setOffset(long offset) {
		this.offset = offset
	}

	@Deprecated
	def addPositionsParsed(long position) {
		positionsParsed += position
		seeks.remove(position)
	}
}
