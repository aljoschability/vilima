package com.aljoschability.vilima.data

import java.util.Comparator
import org.eclipse.emf.ecore.EStructuralFeature
import com.aljoschability.vilima.MkFile

abstract class AbstractVilimaColumn implements Comparator<MkFile> {
}

class VilimaStringColumn extends AbstractVilimaColumn {
	val EStructuralFeature feature

	new(EStructuralFeature feature) {
		this.feature = feature
	}

	override compare(MkFile a, MkFile b) {
		val aFeature = a.eGet(feature) as String
		val bFeature = b.eGet(feature) as String

		return aFeature.compareTo(bFeature)
	}
}
