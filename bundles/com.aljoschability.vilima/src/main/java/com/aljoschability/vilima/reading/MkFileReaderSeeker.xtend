package com.aljoschability.vilima.reading;

import com.aljoschability.vilima.MkTrackType
import com.google.common.base.Charsets
import java.io.ByteArrayInputStream
import java.io.DataInputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.nio.channels.SeekableByteChannel
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardOpenOption
import java.util.Collection
import java.util.LinkedList
import java.util.Queue
import com.aljoschability.vilima.extensions.MkResourceReaderByteOperator
import java.util.Arrays

class MatroskaFileSeeker {
	val ByteBuffer bufferHead
	val ByteBuffer bufferSize

	SeekableByteChannel channel

	long offset
	Queue<Long> seeks
	public Collection<Long> positionsParsed

	new() {
		bufferHead = ByteBuffer::allocateDirect(8)
		bufferSize = ByteBuffer::allocateDirect(8)
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

	def boolean hasSeeks() {
		seeks -= positionsParsed

		return !seeks.empty
	}

	def long nextSeekPosition() {
		seeks.poll
	}

	def offer(long position) {
		seeks.offer(position + offset)
	}

	def setOffset(long offset) {
		this.offset = offset
	}

	def addPositionsParsed(long position) {
		positionsParsed += position
		seeks.remove(position)
	}

	def byte[] readBytes(EbmlElement element) {
		readBytes(element as EbmlDataElement)
	}

	def long readLong(EbmlElement element) {
		readInteger(element as EbmlDataElement)
	}

	def double readDouble(EbmlElement element) {
		readDouble(element as EbmlDataElement)
	}

	def long readTimestamp(EbmlElement element) {
		val data = readBytes(element as EbmlDataElement)

		return readTimestamp(data)
	}

	def String readString(EbmlElement element) {
		readString(element as EbmlDataElement)
	}

	def EbmlElement nextChild(EbmlElement element) {
		return nextChild(element as EbmlMasterElement)
	}

	def int readInt(EbmlElement element) {
		readInteger(element as EbmlDataElement) as int
	}

	def MatroskaNode getNode(EbmlElement element) {
		MatroskaNode::get(element.id)
	}

	def long offset(EbmlElement element) {
		return position - element.headerSize
	}

	def String readHex(EbmlElement element) {
		bytesToHex(element.readBytes)
	}

	def MkTrackType readMkTrackType(EbmlElement element) {
		val value = element.readLong

		switch value {
			case 0x01: return MkTrackType::VIDEO
			case 0x02: return MkTrackType::AUDIO
			case 0x03: return MkTrackType::COMPLEX
			case 0x10: return MkTrackType::LOGO
			case 0x11: return MkTrackType::SUBTITLE
			case 0x20: return MkTrackType::CONTROL
			default: throw new RuntimeException("cannot convert track type from " + value)
		}
	}

	def boolean hasNext(EbmlElement element) {
		if(element instanceof EbmlMasterElement) {
			return element.hasNext
		}

		return false
	}

	def private static byte[] toArray(ByteBuffer buffer) {
		val result = newByteArrayOfSize(buffer.limit)
		buffer.get(result)
		return result
	}

	def EbmlElement nextElement() {

		// read element id
		val id = toArray(readElementId())

		// read element data size
		val dataSize = toArray(readDataSize())

		return createElement(id, dataSize)
	}

	extension MkResourceReaderByteOperator = MkResourceReaderByteOperator::INSTANCE

	def private EbmlElement createElement(byte[] id, byte[] dataSize) {
		val headerSize = id.length + dataSize.length
		val size = bytesToLong(dataSize)
		val node = MatroskaNode.get(id)

		if(node == null) {
			println('''unknown EBML element created: id=«Arrays::toString(id)»; hex=«bytesToHex(id)»''')
			return new EbmlUnknownElement(id, headerSize, size)
		} else if(EbmlElementType::MASTER == node.type) {
			return new EbmlMasterElement(node, headerSize, size);
		} else {
			return new EbmlDataElement(node, headerSize, size);
		}
	}

	def private ByteBuffer readElementId() {
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

		return bufferHead
	}

	def private ByteBuffer readDataSize() {
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

		return bufferSize
	}

	def EbmlElement nextChild(EbmlMasterElement parent) {
		if(!parent.hasNext()) {
			return null
		}

		val element = nextElement()
		if(element == null) {
			return null
		}

		parent.add(element)

		return element
	}

	def long getPosition() {
		return channel.position()
	}

	def private long skip(long offset) {
		if(offset <= 0 || offset > Integer.MAX_VALUE) {
			return 0
		}

		val pos = channel.position();
		val len = channel.size();
		var newpos = pos + offset;
		if(newpos > len) {
			newpos = len
		}
		channel.position(newpos)

		return newpos - pos
	}

	def void skip(EbmlElement element) {
		skip(element.getSkipSize())
	}

	def byte[] readBytes(EbmlDataElement element) {
		if(!element.read()) {
			readData(element)
		}

		return element.getData()
	}

	def double readDouble(EbmlDataElement element) {
		readBytes(element)

		if(EbmlElementType.FLOAT.equals(element.getType())) {
			if(element.getSize() == 4) {
				var float value = 0;
				val bIS = new ByteArrayInputStream(element.getData());
				val dIS = new DataInputStream(bIS);
				value = dIS.readFloat();
				return value;

			} else if(element.getSize() == 8) {
				var double value = 0;
				val bIS = new ByteArrayInputStream(element.getData());
				val dIS = new DataInputStream(bIS);
				value = dIS.readDouble();
				return value;
			}
		}

		throw new RuntimeException();
	}

	def long readInteger(EbmlElement element) {
		readBytes(element)

		switch (element.getType()) {
			case UINTEGER: {
				return bytesToLongUnsigned(element.data);
			}
			default: {
				throw new RuntimeException();
			}
		}
	}

	def byte[] getData(EbmlElement element) {
		if(element instanceof EbmlDataElement) {
			return element.data
		}
	}

	def Boolean readBoolean(EbmlElement element) {
		return readInteger(element) == 1;
	}

	def String readString(EbmlDataElement element) {
		readBytes(element);

		if(EbmlElementType.ASCII.equals(element.getType())) {
			return new String(element.getData(), Charsets.US_ASCII);
		} else if(EbmlElementType.STRING.equals(element.getType())) {
			return new String(element.getData(), Charsets.UTF_8);
		}

		throw new RuntimeException();
	}

	def private void readData(EbmlDataElement element) throws IOException {
		val buffer = ByteBuffer.allocateDirect(element.getSize() as int);

		channel.read(buffer);

		buffer.flip();

		element.setData(toArray(buffer));

		if(element.getSize() > Integer.MAX_VALUE) {
			throw new RuntimeException();
		}
	}

	def EbmlElement nextElement(long position) throws IOException {
		channel.position(position);
		return nextElement();
	}

	def void skipEbmlHeader() {
		val parent = nextElement

		if(!MatroskaNode::EBML.matches(parent)) {
			throw new RuntimeException("EBML root element could not be read.")
		}

		while(parent.hasNext) {
			val element = parent.nextChild

			switch element.node {
				case DocType: {
					val value = element.readString

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
}
