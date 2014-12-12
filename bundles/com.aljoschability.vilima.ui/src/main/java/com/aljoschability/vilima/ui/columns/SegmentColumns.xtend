package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.extensions.ModifyExtension
import com.aljoschability.vilima.extensions.VilimaFormatter

class SegmentTitleColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.title }

	override protected isEditable() { true }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("title", value)) {
				file.information.title = value

				return true
			}
		}
		return false
	}
}

class SegmentUidColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.uid }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("segment-uid", value)) {
				file.information.uid = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }

	override protected useMonospaceFont() { true }
}

class SegmentPreviousUidColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.previousUid }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("prev-uid", value)) {
				file.information.previousUid = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }

	override protected useMonospaceFont() { true }
}

class SegmentNextUidColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.nextUid }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("next-uid", value)) {
				file.information.nextUid = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }

	override protected useMonospaceFont() { true }
}

class SegmentFilenameColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.filename }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("segment-filename", value)) {
				file.information.filename = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }
}

class SegmentPreviousFilenameColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.previousFilename }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("prev-filename", value)) {
				file.information.previousFilename = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }
}

class SegmentNextFilenameColumn extends AbstractStringColumn {
	extension ModifyExtension = ModifyExtension::INSTANCE

	override getString(MkFile file) { file?.information?.nextFilename }

	override protected set(MkFile file, String value) {
		if(file.string != value) {
			if(file.information.write("next-filename", value)) {
				file.information.nextFilename = value

				return true
			}
		}
		return false
	}

	override protected isEditable() { true }
}

class SegmentWritingAppColumn extends AbstractStringColumn {
	override getString(MkFile file) { file?.information?.writingApp }
}

class SegmentMuxingAppColumn extends AbstractStringColumn {
	override getString(MkFile file) { file?.information?.muxingApp }
}

class SegmentDateColumn extends AbstractLongColumn {
	override protected getNumber(MkFile file) { file?.information?.date }

	override getString(MkFile file) { VilimaFormatter::date(file.number) }
}

class SegmentDurationColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTime(file.number) }
}

class SegmentDurationSecondsColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTimeSeconds(file.number) }
}

class SegmentDurationMinutesColumn extends AbstractDoubleColumn {
	override protected getNumber(MkFile file) { file?.information?.duration }

	override getString(MkFile file) { VilimaFormatter::getTimeMinutes(file.number) }
}
