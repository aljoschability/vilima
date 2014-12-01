package com.aljoschability.vilima.extensions

import com.aljoschability.vilima.MkFile

interface TagExtensions {
	val TagExtensions INSTANCE = new TagExtensionsImpl

	def String getMovieTitle(MkFile file)
}

class TagExtensionsImpl implements TagExtensions {
	override getMovieTitle(MkFile file) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
