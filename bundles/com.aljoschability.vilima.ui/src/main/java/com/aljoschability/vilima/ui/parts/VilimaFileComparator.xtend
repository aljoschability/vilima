package com.aljoschability.vilima.ui.parts

import org.eclipse.jface.viewers.ViewerComparator
import org.eclipse.jface.viewers.Viewer
import org.eclipse.jface.viewers.TreeViewer
import com.aljoschability.vilima.ui.columns.ColumnExtension
import org.eclipse.swt.SWT
import com.aljoschability.vilima.ui.columns.ColumnProvider
import com.aljoschability.vilima.MkFile

class VilimaFileComparator extends ViewerComparator {
	override compare(Viewer viewer, Object a, Object b) {
		switch viewer.direction {
			case SWT::UP: viewer.provider.compare(a as MkFile, b as MkFile)
			case SWT::DOWN: viewer.provider.compare(b as MkFile, a as MkFile)
			default: 0
		}
	}

	def private static ColumnProvider getProvider(Viewer viewer) {
		((viewer as TreeViewer).tree.sortColumn?.data as ColumnExtension).provider
	}

	def private static int getDirection(Viewer viewer) { (viewer as TreeViewer).tree.sortDirection }
}
