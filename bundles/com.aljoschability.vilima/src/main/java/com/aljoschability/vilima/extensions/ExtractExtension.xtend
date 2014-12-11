package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.extensions.impl.ExtractExtensionImpl
import java.io.File

interface ExtractExtension {
	val ExtractExtension INSTANCE = new ExtractExtensionImpl

	def File extract(MkAttachment attachment)
}
