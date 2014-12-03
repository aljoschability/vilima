package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import java.util.Collection
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.viewers.CellEditor
import org.eclipse.jface.viewers.CellLabelProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.ColumnViewer
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Map

class ColumnRegistry {
	static val ID = "com.aljoschability.vilima.ui.column"

	boolean initialized = false

	val Collection<ColumnCategoryExtension> categories = newArrayList
	val Map<String, ColumnExtension> columns = newLinkedHashMap

	def Map<String, ColumnExtension> getColumns() {
		if(!initialized) {
			initialize()
		}

		return columns
	}

	def Collection<ColumnCategoryExtension> getColumnCategories() {
		if(!initialized) {
			initialize()
		}

		return categories
	}

	def private void initialize() {
		if(!initialized) {
			val ces = Platform::getExtensionRegistry.getConfigurationElementsFor(ID)

			val cachedCategories = newLinkedHashMap
			val cachedColumns = newArrayList

			// collect registered column categories
			for (ce : ces) {
				if(ce.name == "column") {
					cachedColumns += ce
				} else if(ce.name == "category") {
					val namespace = ce.namespaceIdentifier
					val id = ce.id
					val title = ce.title
					val icon = ce.icon

					if(id == null || title == null) {
						val message = '''Could not register column category with ID "«id»" registered in "«namespace»"!'''
						Activator::get.warn(message)
					} else {
						val category = new ColumnCategoryExtension(namespace, id, title, icon)
						cachedCategories.put(id, category)
						categories += category
					}
				}
			}

			// collect columns
			for (ce : cachedColumns) {
				val id = ce.id
				val title = ce.title
				val desc = ce.description
				val provider = ce.columnProvider
				val width = ce.width
				val alignment = ce.alignment
				val category = cachedCategories.get(ce.category)

				if(id == null || title == null || provider == null) {
					val namespace = ce.namespaceIdentifier
					val message = '''Could not register column extension with ID "«id»" registered in "«namespace»"!'''
					Activator::get.warn(message)
				} else {
					val column = new ColumnExtension(id, title, desc, provider, width, alignment)
					if(category != null) {
						category.addColumn(column)
					}
					columns.put(id, column)
				}
			}

			initialized = true
		}
	}

	def private static String getId(IConfigurationElement element) {
		element.getAttribute("id")
	}

	def private static String getTitle(IConfigurationElement element) {
		element.getAttribute("title")
	}

	def private static String getIcon(IConfigurationElement element) {
		element.getAttribute("icon")
	}

	def private static String getDescription(IConfigurationElement element) {
		element.getAttribute("description")
	}

	def private static int getWidth(IConfigurationElement element) {
		val width = element.getAttribute("width")
		if(width == null) {
			return 100
		}
		return Integer.parseInt(width)
	}

	def private static int getAlignment(IConfigurationElement element) {
		val alignment = element.getAttribute("alignment")
		if(alignment == "CENTER") {
			return SWT::CENTER
		}
		if(alignment == "TRAIL") {
			return SWT::TRAIL
		}
		return SWT::LEAD
	}

	def private static String getCategory(IConfigurationElement element) {
		element.getAttribute("category")
	}

	def private static ColumnProvider getColumnProvider(IConfigurationElement ce) {
		try {
			val object = ce.createExecutableExtension("provider");
			if(object instanceof ColumnProvider) {
				return object
			}
		} catch(CoreException e) {
			// just ignore exception
		}
		return null
	}
}

@Accessors class ColumnCategoryExtension {
	val String namespace
	val String id
	val String name
	val String imagePath
	Collection<ColumnExtension> columns = newArrayList

	def void addColumn(ColumnExtension column) {
		columns += column
		column.category = this
	}
}

@Accessors class ColumnExtension {
	val String id
	val String name
	val String description
	val ColumnProvider provider
	val int width
	val int alignment
	ColumnCategoryExtension category

	def void setCategory(ColumnCategoryExtension category) {
		this.category = category
	}
}

interface ColumnProvider {
	@Deprecated
	def CellLabelProvider getLabelProvider()

	def int compare(MkFile a, MkFile b)
}

interface EditableColumnProvider extends ColumnProvider {
	def CellEditor getCellEditor(Composite control, MkFile file)

	def Object getValue(MkFile file)

	def boolean setValue(MkFile file, Object value)
}

abstract class MkFileLabelProvider extends ColumnLabelProvider {
	override getText(Object element) {
		if(element instanceof MkFile) {
			return getText(element)
		}
		return super.getText(element)
	}

	def String getText(MkFile element)
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
