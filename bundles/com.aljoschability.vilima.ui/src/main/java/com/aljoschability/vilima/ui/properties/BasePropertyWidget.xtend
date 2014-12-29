package com.aljoschability.vilima.ui.properties

import com.aljoschability.vilima.ui.extensions.SwtExtension
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import com.aljoschability.core.ui.CoreImages
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.emf.databinding.EMFObservables
import org.eclipse.emf.ecore.EObject
import org.eclipse.core.databinding.DataBindingContext
import org.eclipse.jface.databinding.swt.WidgetProperties
import org.eclipse.emf.databinding.EMFProperties
import org.eclipse.emf.ecore.EStructuralFeature

/**
 * @param E The element type.
 * @param V The value type.
 */
abstract class BasePropertyWidget<E extends EObject, V> {
	protected static val EMPTY = ""

	protected extension SwtExtension = SwtExtension::INSTANCE

	protected E element

	Label helpWidget

	/* creates the controls on the given parent (3 columns) */
	def final void createWidget(Composite parent) {
		createLabelWidget(parent)
		createControlWidget(parent)
		createHelpWidget(parent)
	}

	def protected void createLabelWidget(Composite parent)

	def protected void createControlWidget(Composite parent)

	def private void createHelpWidget(Composite parent) {
		helpWidget = parent.newLabel(
			[
				layoutData = newGridDataCentered
				image = CoreImages::get(CoreImages::STATE_INFORMATION)
				enabled = false
			], SWT::CENTER)
	}

	/* configures the controls for the given element */
	def void setElement(E element) {
		this.element = element
	}

	/* validates the value before the value is set. */
	def void validateValue(E element, V value) {
		println('''validateValue(«element», «value»)''')
	}

	/* gets the value for the element */
	def V getValue(E element) {
		println('''getValue«element»''')
		return null
	}

	/* sets the value for the element */
	def void setValue(E element, V value) {
		println('''setValue(«element», «value»)''')
	}
}

class BasePropertyTextWidget<E extends EObject> extends BasePropertyWidget<E, String> {
	val String labelDescription

	Label labelWidget
	Text controlWidget

	new(String labelDescription) {
		this.labelDescription = labelDescription
	}

	def protected EStructuralFeature getFeature() {
		return null
	}

	override void setElement(E element) {
		val bindingContext = new DataBindingContext()
		bindingContext.bindValue(WidgetProperties::text(SWT.FocusOut).observe(controlWidget),
			EMFProperties::value(getFeature()).observe(element))

		if(this.element != null) {
			println('''unbind text control from element''')
		}
		if(element != null) {
			println('''bind text control to element''')
		}
		super.setElement(element)
	}

	override protected createLabelWidget(Composite parent) {
		labelWidget = parent.newLabel(
			[
				layoutData = newGridDataCentered
				text = '''«labelDescription»:'''
			], SWT::TRAIL)
	}

	override protected createControlWidget(Composite parent) {
		controlWidget = parent.newText(
			[
				layoutData = newGridData(true, false)
				enabled = false
				font = if(useMonospaceFont) JFaceResources::textFont
				addModifyListener(newModifyListener[validateValue(element, controlWidget.text)])
				addFocusListener(newFocusLostListener[setValue(element, controlWidget.text)])
			], SWT::BORDER)
	}

	def protected boolean useMonospaceFont() { false }
}
