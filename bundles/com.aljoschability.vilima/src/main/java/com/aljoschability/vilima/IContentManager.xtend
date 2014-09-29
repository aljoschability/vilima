package com.aljoschability.vilima

interface IContentManager {
	def void clear()

	def String getPath()

	def void setPath(String path)

	def void add(MkvFile file)
	
	def VilimaContent getContent()
	
}
