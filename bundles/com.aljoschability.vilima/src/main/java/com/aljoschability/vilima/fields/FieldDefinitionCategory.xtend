package com.aljoschability.vilima.fields

interface FieldDefinitionCategory {

	/* The <b>non-empty</b> and <b>unique</b> identifier of the field category. */
	def String getId()

	/* The <b>required</b> and <b>non-empty</b> name of the field category. */
	def String getName()

	/* The (<b>optional</b> but <i>recommended</i>) description of the field category. */
	def String getDescription()

	/* The bundle name in which the image is stored. */
	def String getImageBundle()

	/* The image path inside the bundle. */
	def String getImagePath()
}
