package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkInformation
import com.aljoschability.vilima.extensions.impl.ModifyExtensionImpl
import com.aljoschability.vilima.MkFile

interface ModifyExtension {
	val ModifyExtension INSTANCE = new ModifyExtensionImpl

	def boolean writeAll(MkInformation information)

	def boolean writeInfo(MkFile file, String name, String value)
}
