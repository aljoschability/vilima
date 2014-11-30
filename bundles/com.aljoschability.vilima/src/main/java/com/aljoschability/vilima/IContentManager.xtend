package com.aljoschability.vilima

interface IContentManager {
	def void clear()

	def String getPath()

	def void setPath(String path)

	def void add(MkFile file)

	def XVilimaLibrary getContent()

	def void refresh()

	def XVilimaLibrary getLibrary()
}
