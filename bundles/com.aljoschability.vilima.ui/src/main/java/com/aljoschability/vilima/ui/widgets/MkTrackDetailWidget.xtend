package com.aljoschability.vilima.ui.widgets

import org.eclipse.swt.widgets.Composite
import com.aljoschability.vilima.MkTrack
import com.aljoschability.vilima.ui.extensions.SwtExtension
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Label
import com.aljoschability.core.ui.CoreImages
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.Button
import org.eclipse.jface.layout.GridDataFactory

/* parent has 3 columns: first for a description, second for the actual field, last for detail information */
abstract class MkTrackDetailWidget {
	protected extension SwtExtension = SwtExtension::INSTANCE

	val String helpText

	Label helpControl

	new(String helpText) {
		this.helpText = helpText
	}

	def void create(Composite parent) {
		parent.createContentControls()
		parent.createHelpControl()
	}

	def protected void createContentControls(Composite parent)

	def protected createHelpControl(Composite parent) {
		helpControl = parent.newLabel(
			[
				layoutData = newGridDataCentered
				image = CoreImages::get(CoreImages::STATE_QUESTION)
				toolTipText = helpText
			], SWT::CENTER)
	}

	def void update(MkTrack track) {
		updateContents(track)
		updateHelp(helpControl, track)
	}

	def protected void updateContents(MkTrack track)

	def protected void updateHelp(Label helpControl, MkTrack track) {
	}
}

abstract class MkTrackDetailTextWidget extends MkTrackDetailWidget {
	val String description

	protected Text widget

	Label label

	new(String description, String help) {
		super(help)

		this.description = description
	}

	override protected createContentControls(Composite parent) {
		label = parent.newLabel(
			[
				layoutData = newGridDataCentered
				text = description + ":"
			], SWT::TRAIL)

		widget = parent.newText(
			[
				layoutData = newGridData(true, false)
				enabled = false
			], SWT::BORDER)
	}
}

abstract class MkTrackDetailCheckWidget extends MkTrackDetailWidget {
	val String description

	protected Button widget

	new(String description, String help) {
		super(help)

		this.description = description
	}

	override protected createContentControls(Composite parent) {
		val composite = parent.newComposite [
			layout = newGridLayout(2)
			layoutData = GridDataFactory::fillDefaults.span(2, 1).grab(true, true).create
		]

		widget = composite.newButton(
			[
				text = description
				enabled = false
			], SWT::CHECK)
	}
}
