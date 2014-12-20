package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkChapter
import com.aljoschability.vilima.MkEdition
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkSegment
import com.aljoschability.vilima.MkTag
import com.aljoschability.vilima.MkTagNode
import com.aljoschability.vilima.MkTrack
import org.eclipse.core.runtime.IStatus

interface MkFileWriter {
	def IStatus write(MkFile file)
}

interface MkSegmentWriter {
	def IStatus write(MkSegment segment)
}

class MkSegmentWriterImpl implements MkSegmentWriter {
	override write(MkSegment segment) {
		segment.date

		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}

interface MkTrackWriter {
	def IStatus write(MkTrack track)
}

interface MkChapterWriter {

	//val MkChapterWriter INSTANCE = new MkChapterWriterImpl
	def IStatus write(MkEdition edition)

	def IStatus write(MkChapter chapter)
}

interface MkAttachmentWriter {
	def IStatus write(MkAttachment attachment)
}

interface MkTagWriter {
	def IStatus write(MkTag tag)

	def IStatus write(MkTagNode tagNode)
}
