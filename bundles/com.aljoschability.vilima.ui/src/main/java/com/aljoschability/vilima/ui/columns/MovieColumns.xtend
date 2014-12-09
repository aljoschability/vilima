package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.MkTagNode
import java.util.Collection

interface TagExtensions {
	val INSTANCE = new TagExtensionsImpl

	def Collection<MkTagNode> getAllTagNodes(MkFile file, Integer target, String name)

	def MkTagNode getTagNode(MkFile file, Integer target, String name)
}

class TagExtensionsImpl implements TagExtensions {
	override getAllTagNodes(MkFile file, Integer target, String name) {
		val list = newArrayList
		file.tags.filter[it.target == target].forEach[list += nodes.filter[it.name == name]]
		return list
	}

	override getTagNode(MkFile file, Integer target, String name) {
		val nodes = getAllTagNodes(file, target, name)
		switch nodes.size {
			case 0:
				return null
			case 1:
				return nodes.head
			default: {
				println('''File "«file.name»" has multiple tags for «target»:«name» («nodes»)!''')
				return nodes.head
			}
		}
	}

	/* this would be the exact one */
	def private String getExactValue(MkFile file, Integer target, String targetText, String name, String language) {
		for (tag : file.tags) {
			if(tag.target == target && tag.targetText == targetText) {
				for (node : tag.nodes) {
					if(node.name == name && node.language == language) {
						return node.value
					}
				}
			}
		}
		return null
	}
}

class MovieCollectionTitleColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(70, "TITLE")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieCollectionSummaryColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(70, "SUMMARY")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieTitleColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(50, "TITLE")?.value
	}

	def private String getSegmentTitle(MkFile file) {
		return file?.information?.title
	}

	override protected getDiagnose(MkFile file) {
		if(file.segmentTitle != file.string) {
			return warning("tag and segment mismatch!")
		}
		if(file.string != null && file.string.trim.empty) {
			return error("The title is set but empty!")
		}
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieSubtitleColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(50, "SUBTITLE")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieDateReleaseColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(50, "DATE_RELEASED")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieSummaryColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(50, "SUMMARY")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}

class MovieCommentColumn extends AbstractStringColumn {
	override getString(MkFile file) {
		file?.getTagNode(50, "COMMENT")?.value
	}

	override protected set(MkFile file, String string) {
		if(file.string != string) {
			println('''Store tag: "«file.string»" := "«string»".''')

			return true
		}
		return false
	}
}
/*
* 50:MOVIE#ID_TMDB --> TMDb ID
* 50:MOVIE#ID_IMDB --> IMDB ID
*/
