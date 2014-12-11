package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkInformation
import com.aljoschability.vilima.extensions.impl.ModifyExtensionImpl

interface ModifyExtension {
	val ModifyExtension INSTANCE = new ModifyExtensionImpl

	def boolean writeAll(MkInformation information)

	def boolean write(MkInformation information, String name, String value)
}
