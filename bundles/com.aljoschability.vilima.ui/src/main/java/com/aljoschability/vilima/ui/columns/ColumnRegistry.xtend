package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import java.util.Collection
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.viewers.CellEditor
import org.eclipse.jface.viewers.ColumnViewer
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

class ColumnRegistry {
	static val ID = "com.aljoschability.vilima.ui.column"

	static val ATTR_ID = "id"
	static val ATTR_NAME = "name"
	static val ATTR_DESC = "description"
	static val ATTR_CLASS = "class"

	Collection<ColumnExtension> columns

	def Collection<ColumnExtension> getColumnExtensions() {
		if(columns == null) {
			columns = newArrayList

			val ces = Platform::getExtensionRegistry.getConfigurationElementsFor(ID)

			for (ce : ces) {
				val id = ce.getAttribute(ATTR_ID)
				val name = ce.getAttribute(ATTR_NAME)
				val desc = ce.getAttribute(ATTR_DESC)
				val provider = getProvider(ce)

				if(id == null || name == null || provider == null) {
					Activator::get.warn('''Could not register column extension with ID «id»!''')
				} else {
					val column = new ColumnExtensionImpl(id, name, desc, provider)
					columns += column
					println(column)
				}
			}
		}

		return columns
	}

	def private static ColumnProvider getProvider(IConfigurationElement ce) {
		try {
			val object = ce.createExecutableExtension(ATTR_CLASS);
			if(object instanceof ColumnProvider) {
				return object
			}
		} catch(CoreException e) {
			// just ignore exception
		}
		return null
	}
}

interface ColumnExtension {
	def int getStyle()

	def String getName()

	def ColumnProvider getProvider()
}

@Data @ToString @EqualsHashCode
class ColumnExtensionImpl implements ColumnExtension {
	String id
	String name
	String description
	ColumnProvider provider

	override getStyle() {
		SWT::LEAD
	}
}

interface ColumnProvider {
	def String getText(MkFile file)
}

interface EditableColumnProvider extends ColumnProvider {
	def CellEditor getCellEditor(Composite control, MkFile file)

	def Object getValue(MkFile file)

	def boolean setValue(MkFile file, Object value)
}

class VilimaEditingSupport extends EditingSupport {
	EditableColumnProvider provider

	new(ColumnViewer viewer, EditableColumnProvider provider) {
		super(viewer)

		this.provider = provider
	}

	override protected getCellEditor(Object element) {
		provider.getCellEditor(viewer.control as Composite, element as MkFile)
	}

	override protected canEdit(Object element) { true }

	override protected getValue(Object element) {
		provider.getValue(element as MkFile)
	}

	override protected setValue(Object element, Object value) {
		if(provider.setValue(element as MkFile, value)) {
			viewer.update(element, null)
		}
	}
}
