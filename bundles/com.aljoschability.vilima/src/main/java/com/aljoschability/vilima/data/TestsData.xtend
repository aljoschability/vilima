package com.aljoschability.vilima.data

import com.aljoschability.vilima.MkvFile
import java.util.Comparator
import org.eclipse.emf.ecore.EStructuralFeature

abstract class AbstractVilimaColumn implements Comparator<MkvFile> {
}

class VilimaStringColumn extends AbstractVilimaColumn {
	val EStructuralFeature feature

	new(EStructuralFeature feature) {
		this.feature = feature
	}

	override compare(MkvFile a, MkvFile b) {
		val aFeature = a.eGet(feature) as String
		val bFeature = b.eGet(feature) as String

		return aFeature.compareTo(bFeature)
	}
}
