package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTrackType
import com.aljoschability.vilima.format.VilimaFormatter

class TrackCodecsColumn implements ColumnProvider {
	override compare(MkFile a, MkFile b) {
		println('''did not really sort, returned 0''')
		return 0
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) {
				val text = new StringBuilder

				for (var i = 0; i < file.tracks.size; i++) {
					val track = file.tracks.get(i)

					text.append(track.codecId)

					if(i < file.tracks.size - 1) {
						text.append(", ")
					}
				}
				return text.toString
			}
		}
	}
}

class VideoTrackCodecsProvider implements ColumnProvider {
	override compare(MkFile a, MkFile b) {
		println('''did not really sort, returned 0''')
		return 0
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) {
				val text = new StringBuilder

				for (var i = 0; i < file.tracks.size; i++) {
					val track = file.tracks.get(i)

					if(track.type == MkTrackType::VIDEO) {
						text.append(VilimaFormatter::getTrackInfo(track))
					}
				}
				return text.toString
			}
		}
	}
}

class VideoTrackHdProvider implements ColumnProvider {
	override compare(MkFile a, MkFile b) {
		println('''did not really sort, returned 0''')
		return 0
	}

	override getLabelProvider() {
		new MkFileLabelProvider {
			override getText(MkFile file) {
				for (track : file.tracks) {
					if(track.type == MkTrackType::VIDEO) {
						return String.valueOf(track.videoPixelWidth)
					}
				}
				return ""
			}
		}
	}
}
