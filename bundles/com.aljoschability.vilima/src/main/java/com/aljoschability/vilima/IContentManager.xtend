package com.aljoschability.vilima

interface IContentManager {
	def void clear()

	def String getPath()

	def void setPath(String path)

	def void add(VilimaFile file)

	def VilimaContent getContent()

	def void refresh()
}
