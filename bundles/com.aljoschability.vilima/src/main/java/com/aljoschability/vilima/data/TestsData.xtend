package com.aljoschability.vilima.data

import java.util.Comparator
import org.eclipse.emf.ecore.EStructuralFeature
import com.aljoschability.vilima.VilimaFile

abstract class AbstractVilimaColumn implements Comparator<VilimaFile> {
}

class VilimaStringColumn extends AbstractVilimaColumn {
	val EStructuralFeature feature

	new(EStructuralFeature feature) {
		this.feature = feature
	}

	override compare(VilimaFile a, VilimaFile b) {
		val aFeature = a.eGet(feature) as String
		val bFeature = b.eGet(feature) as String

		return aFeature.compareTo(bFeature)
	}
}
