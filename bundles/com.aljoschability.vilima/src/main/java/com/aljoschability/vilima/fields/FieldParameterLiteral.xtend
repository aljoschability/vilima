package com.aljoschability.vilima.fields

/* Represents a field parameter literal. */
interface FieldParameterLiteral {

	/* The name which is used internally to store and load field parameter values. */
	def String getName()

	/* Represents the title of the field parameter literal which is used in the user interface. */
	def String getTitle()
}
