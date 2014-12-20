package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.extensions.impl.ModifyExtensionImpl
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkSegment

interface ModifyExtension {
	val ModifyExtension INSTANCE = new ModifyExtensionImpl

	def boolean writeAll(MkSegment information)

	def boolean writeInfo(MkFile file, String name, String value)
}
