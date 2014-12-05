package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.columns.MkFileColumn
import com.aljoschability.vilima.ui.columns.MkFileColumnExtension
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.jface.viewers.Viewer
import org.eclipse.jface.viewers.ViewerComparator
import org.eclipse.swt.SWT

class VilimaFileComparator extends ViewerComparator {
	override compare(Viewer viewer, Object a, Object b) {
		switch viewer.direction {
			case SWT::UP: viewer.provider.compare(a as MkFile, b as MkFile)
			case SWT::DOWN: viewer.provider.compare(b as MkFile, a as MkFile)
			default: 0
		}
	}

	def private static MkFileColumn getProvider(Viewer viewer) {
		((viewer as TreeViewer).tree.sortColumn?.data as MkFileColumnExtension).provider
	}

	def private static int getDirection(Viewer viewer) { (viewer as TreeViewer).tree.sortDirection }
}
