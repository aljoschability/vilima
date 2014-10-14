package com.aljoschability.vilima

interface IContentManager {
	def void clear()

	def String getPath()

	def void setPath(String path)

	def void add(MkFile file)

	def VilimaLibrary getContent()

	def void refresh()
}
