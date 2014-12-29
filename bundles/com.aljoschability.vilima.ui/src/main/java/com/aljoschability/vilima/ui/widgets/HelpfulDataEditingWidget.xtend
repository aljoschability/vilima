package com.aljoschability.vilima.ui.widgets

import com.aljoschability.core.ui.CoreImages
import com.aljoschability.vilima.ui.extensions.SwtExtension
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.events.FocusAdapter
import org.eclipse.swt.events.FocusEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.ModifyEvent

abstract class BaseWidget<E> {
	protected static val EMPTY = ""

	protected extension SwtExtension = SwtExtension::INSTANCE

	val String helpMessage

	protected E element

	protected Label helpControl

	new(String helpMessage) {
		this.helpMessage = helpMessage
	}

	/* creates the controls on the given parent */
	def final void create(Composite parent) {
		parent.createControls()

		helpControl = parent.newLabel(
			[
				layoutData = newGridDataCentered
				image = CoreImages::get(CoreImages::STATE_INFORMATION)
				enabled = false
			], SWT::CENTER)
	}

	/* should create the needed controls for the widget on the given parent (2 column grid layout). */
	def protected void createControls(Composite parent)

	/* is called when the input element has been changed. */
	def final void setInput(E element) {
		if(this.element == element) {
			return
		}

		this.element = element

		if(element == null) {
			clear()
		} else {
			val value = element.value
			val state = getState(element, value)
			inputChanged(element, value, state)
		}
	}

	/* Called when the element is <code>null</code>.
	 * Should reset all UI elements.
	 * Do not forget to call <code>super</code>.
	 */
	def protected void clear() {
		if(helpControl.active) {
			helpControl.enabled = false
			helpControl.toolTipText = helpMessage
			helpControl.image = CoreImages::get(CoreImages::STATE_INFORMATION)
		}
	}

	/* Called when a new element is should be shown.
	 * Do not forget to <b>call <code>super</code></b>.
	 */
	def protected void inputChanged(E element, Object value, ElementState state) {
		if(helpControl.active) {
			helpControl.enabled = true
			helpControl.image = state?.image
			helpControl.toolTipText = state?.message
		}
	}

	/* must return the current value for the given element. */
	def protected Object getValue(E element)

	/* must return the status of the elements value. */
	def protected ElementState getState(E element, Object value) {
		ElementState::newInformation(helpMessage)
	}
}

abstract class BaseTextWidget<E> extends BaseWidget<E> {
	val String labelValue

	Label labelControl
	Text valueControl

	new(String labelValue, String helpMessage) {
		super(helpMessage)
		this.labelValue = labelValue
	}

	override protected createControls(Composite parent) {
		labelControl = parent.newLabel(
			[
				layoutData = newGridDataCentered
				text = '''«labelValue»:'''
			], SWT::TRAIL)

		valueControl = parent.newText(
			[
				layoutData = newGridData(true, false)
				enabled = false
				addModifyListener(newModifyListener[validateValue(element, valueControl.text)])
				addFocusListener(newFocusLostListener[setValue(element, valueControl.text)])
			], SWT::BORDER)
	}

	def protected void validateValue(E element, String text) {
		
		println('''validate value "«text»" for element «element»''')
	}

	def protected void setValue(E element, String value)

	override protected clear() {
		if(valueControl.active) {
			valueControl.enabled = false
			valueControl.text = EMPTY
		}
		super.clear()
	}

	override protected inputChanged(E element, Object value, ElementState state) {
		valueControl.enabled = true

		valueControl.background = state?.color
		valueControl.text = value as String ?: ""

		super.inputChanged(element, value, state)
	}

	def final void modifyValue(E element, String value) {
		if(element == null) {
			return
		}

		setValue(element, value)
	}

}

/* parent has 3 columns: first for a description, second for the actual field, last for detail information */
abstract class HelpfulDataEditingWidget<T> {
	protected extension SwtExtension = SwtExtension::INSTANCE

	val protected String description

	protected Label helpControl

	new(Composite parent, String description) {
		this.description = description

		parent.createContentControls()
		parent.createHelpControl()
	}

	def protected void createContentControls(Composite parent)

	def protected createHelpControl(Composite parent) {
		helpControl = parent.newLabel(
			[
				layoutData = newGridDataCentered
				image = CoreImages::get(CoreImages::STATE_QUESTION)
			], SWT::CENTER)
	}

	def void setInput(T element) {
		update(element)
	}

	def protected void update(T element)

	def protected void info(Label control, String text) {
		control.fill(CoreImages::get(CoreImages::STATE_INFORMATION), text)
	}

	def protected void warning(Label control, String text) {
		control.fill(CoreImages::get(CoreImages::STATE_WARNING), text)
	}

	def protected void error(Label control, String text) {
		control.fill(CoreImages::get(CoreImages::STATE_ERROR), text)
	}

	def private void fill(Label control, Image image, String text) {
		control.image = image
		control.toolTipText = text
	}
}

abstract class HelpfulTextEditingWidget<T> extends HelpfulDataEditingWidget<T> {
	Label label

	protected Text widget

	new(Composite parent, String description) {
		super(parent, description)
	}

	protected def String getValue(T element)

	protected def void setValue(T element, String value)

	override protected createContentControls(Composite parent) {
		label = parent.newLabel(
			[
				layoutData = newGridDataCentered
				text = '''«description»:'''
			], SWT::TRAIL)

		widget = parent.newText(
			[
				layoutData = newGridData(true, false)
				enabled = false
			], SWT::BORDER)
	}

	override protected update(T element) {
		widget.text = element.value ?: ""
	}
}

abstract class HelpfulCheckboxEditingWidget<T> extends HelpfulDataEditingWidget<T> {
	protected Button widget

	new(Composite parent, String description) {
		super(parent, description)
	}

	override protected createContentControls(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayout(2)
			layoutData = GridDataFactory::fillDefaults.span(2, 1).grab(true, false).create
		]

		widget = composite.newButton(
			[
				text = description
				enabled = false
			], SWT::CHECK)
	}
}
