package com.aljoschability.vilima.ui.columns

import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import java.util.Collection
import java.util.Comparator
import java.util.Map
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.viewers.CellLabelProvider
import org.eclipse.jface.viewers.ColumnLabelProvider
import org.eclipse.jface.viewers.EditingSupport
import org.eclipse.jface.viewers.ICellEditorValidator
import org.eclipse.jface.viewers.TextCellEditor
import org.eclipse.jface.viewers.TreeViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Color
import org.eclipse.swt.graphics.Font
import org.eclipse.swt.widgets.Display
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

@Accessors class MkFileColumnCategoryExtension {
	val String namespace
	val String id
	val String name
	val String imagePath
	Collection<MkFileColumnExtension> columns = newArrayList

	def void addColumn(MkFileColumnExtension column) {
		columns += column
		column.category = this
	}
}

@Accessors class MkFileColumnExtension {
	val String id
	val String name
	val String description
	val MkFileColumn provider
	val int width
	val int alignment
	MkFileColumnCategoryExtension category

	def void setCategory(MkFileColumnCategoryExtension category) {
		this.category = category
	}
}

class MkFileColumnRegistry {
	static val ID = "com.aljoschability.vilima.ui.column"

	boolean initialized = false

	val Collection<MkFileColumnCategoryExtension> categories = newArrayList
	val Map<String, MkFileColumnExtension> columns = newLinkedHashMap

	def Map<String, MkFileColumnExtension> getColumns() {
		if(!initialized) {
			initialize()
		}

		return columns
	}

	def Collection<MkFileColumnCategoryExtension> getColumnCategories() {
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
						val category = new MkFileColumnCategoryExtension(namespace, id, title, icon)
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
					val column = new MkFileColumnExtension(id, title, desc, provider, width, alignment)
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

	def private static MkFileColumn getColumnProvider(IConfigurationElement ce) {
		try {
			val object = ce.createExecutableExtension("provider");
			if(object instanceof MkFileColumn) {
				return object
			}
		} catch(CoreException e) {
			// just ignore exception
		}
		return null
	}

}

interface MkFileColumn extends Comparator<MkFile> {
	def CellLabelProvider getLabelProvider()

	def EditingSupport getEditingSupport(TreeViewer viewer)
}

interface CompareExtensions {
	val INSTANCE = new CompareExtensions {
		override compareStrings(String value1, String value2) {
			if(value1 == value2) {
				return 0
			}

			if(value1 != null && value2 != null) {
				return value1.compareToIgnoreCase(value2)
			}

			if(value2 != null) {
				return -1
			}

			return 1
		}

		override compareLongs(Long value1, Long value2) {
			if(value1 == value2) {
				return 0
			}

			if(value1 != null && value2 != null) {
				return value1.compareTo(value2)
			}

			if(value2 != null) {
				return -1
			}

			return 1
		}

		override compareDoubles(Double value1, Double value2) {
			if(value1 == value2) {
				return 0
			}

			if(value1 != null && value2 != null) {
				return value1.compareTo(value2)
			}

			if(value2 != null) {
				return -1
			}

			return 1
		}

		override compareIntegers(Integer value1, Integer value2) {
			if(value1 == value2) {
				return 0
			}

			if(value1 != null && value2 != null) {
				return value1.compareTo(value2)
			}

			if(value2 != null) {
				return -1
			}

			return 1
		}
	}

	def int compareIntegers(Integer value1, Integer value2)

	def int compareLongs(Long value1, Long value2)

	def int compareDoubles(Double value1, Double value2)

	def int compareStrings(String value1, String value2)
}

enum MkFileDiagnoseStatus {
	NONE,
	WARNING,
	ERROR
}

@Data class MkFileDiagnose {
	MkFileDiagnoseStatus status
	String message
}

abstract class AbstractStringColumn implements MkFileColumn {
	protected extension CompareExtensions = CompareExtensions::INSTANCE
	protected extension TagExtensions = TagExtensions::INSTANCE
	protected extension DiagnoseExtensions = DiagnoseExtensions::INSTANCE

	ColumnLabelProvider labelProvider

	protected EditingSupport editingSupport

	override compare(MkFile file1, MkFile file2) { compareStrings(file1.string, file2.string) }

	def private MkFileDiagnose getDiagnose(Object object) { getDiagnose(object as MkFile) }

	def protected MkFileDiagnose getDiagnose(MkFile file) { null }

	def private Color getColor(MkFileDiagnose diagnose) {
		if(diagnose != null) {

			// TODO: color service possibly needed
			println('''CoreColors not available anymore!''')
			switch diagnose.status {
				//case WARNING: return CoreColors::get(CoreColors::WARNING)
				//case ERROR: return CoreColors::get(CoreColors::ERROR)
				default: return null
			}
		}
	}

	override getLabelProvider() {
		if(labelProvider == null) {
			labelProvider = new ColumnLabelProvider {
				override getText(Object element) {
					element.string ?: ""
				}

				override useNativeToolTip(Object object) { true }

				override getToolTipText(Object element) {
					element?.diagnose?.message
				}

				override getForeground(Object element) {
					val s = element?.string

					if(s == "Basic Instinct 2") {
						return Display::getCurrent.getSystemColor(SWT::COLOR_DARK_GRAY)
					}
				}

				override getBackground(Object element) {
					element?.diagnose?.color
				}

				override getFont(Object element) {
					if(useMonospaceFont) {
						return JFaceResources::getTextFont
					} else {
						return null
					}
				}
			}
		}
		return labelProvider
	}

	override getEditingSupport(TreeViewer treeViewer) {
		if(editable && editingSupport == null) {
			editingSupport = new EditingSupport(treeViewer) {
				override protected canEdit(Object element) {
					element instanceof MkFile
				}

				override protected getCellEditor(Object element) {
					val editor = new TextCellEditor(treeViewer.tree)
					editor.validator = validator
					return editor
				}

				override protected getValue(Object element) {
					(element as MkFile).string ?: ""
				}

				override protected setValue(Object element, Object value) {
					if(set(element as MkFile, value as String)) {
						viewer.update(element, null)
					}
				}
			}
		}
		return editingSupport
	}

	def protected ICellEditorValidator getValidator() { null }

	def protected Font getFont() { null }

	def protected boolean isEditable() { false }

	def protected boolean useMonospaceFont() { false }

	def protected boolean set(MkFile file, String string) { false }

	def private String getString(Object object) { getString(object as MkFile) }

	def protected String getString(MkFile file)
}

interface DiagnoseExtensions {
	val INSTANCE = new DiagnoseExtensions {
		override warning(String message) {
			return new MkFileDiagnose(MkFileDiagnoseStatus::WARNING, message)
		}

		override error(String message) {
			return new MkFileDiagnose(MkFileDiagnoseStatus::ERROR, message)
		}
	}

	def MkFileDiagnose warning(String message)

	def MkFileDiagnose error(String message)
}

abstract class AbstractLongColumn extends AbstractStringColumn {
	override compare(MkFile file1, MkFile file2) { compareLongs(file1.number, file2.number) }

	def protected Long getNumber(MkFile file)

	override protected getString(MkFile file) {
		String::valueOf(file.number)
	}

	override protected set(MkFile file, String string) {
		set(file, Long.parseLong(string))
	}

	def protected boolean set(MkFile file, Long value) { false }
}

abstract class AbstractDoubleColumn extends AbstractStringColumn {
	override compare(MkFile file1, MkFile file2) { compareDoubles(file1.number, file2.number) }

	def protected Double getNumber(MkFile file)

	override protected getString(MkFile file) {
		String::valueOf(file.number)
	}

	override protected set(MkFile file, String string) {
		set(file, Double.parseDouble(string))
	}

	def protected boolean set(MkFile file, Double value) { false }
}
