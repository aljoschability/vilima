package com.aljoschability.vilima.fields

import java.util.Map

interface FieldDefinition {

	/* The <b>non-empty</b> and <b>unique</b> identifier of the field. */
	def String getId()

	/* The <b>required</b> and <b>non-empty</b> name of the field. This is also used as default title when a new field is created. */
	def String getName()

	/* The (<b>optional</b> but <i>recommended</i>) description of the field. This is shown in the user interface and should describe what the field actually shows and possibly edits. */
	def String getDescription()

	/* The category to which this field belongs. */
	def FieldDefinitionCategory getCategory()

	/* The default width of the field when used as column. */
	def int getDefaultWidth()

	/* The default alignment of the field when used as column. */
	def String getDefaultAlignment()

	/* Whether to show the field value in a monospace font by default. */
	def boolean isDefaultMonospace()

	/* The field provider that handles the values. */
	def FieldProvider getProvider()

	/* The parameters for the field. */
	def Map<String, FieldDefinitionParameter> getParameters()
}
