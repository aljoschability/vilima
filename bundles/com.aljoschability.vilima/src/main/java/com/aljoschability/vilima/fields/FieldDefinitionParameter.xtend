package com.aljoschability.vilima.fields

import java.util.Map

/* Represents a field parameter. */
interface FieldDefinitionParameter {

	/* The name is used to identify the parameter. It must be unique for the containing field. */
	def String getName()

	/* The short, not-empty and human-readable title for the parameter that is used in the user interface. */
	def String getTitle()

	/* The type of the parameter that is needed to decide how to handle the parameter value. */
	def FieldDefinitionParameterType getType()

	/* The (optional) default value of the parameter as String. When not defined or invalid, the following values are used. Can be null. */
	def String getDefaultValue()

	/* The (optional) description is used in the user interface to help the user understanding the impact of the parameter. */
	def String getDescription()

	/* The (optional) validator class is used to check the parameters value when given. When empty every value is assumed to be valid. This is especially recommended for String type parameters. */
	def FieldParameterValidator getValidator()

	/* The literals define the possible values a enumeration type parameter can have. It is an immutable map with their index as key. */
	def Map<Integer, FieldDefinitionParameterLiteral> getLiterals()
}

/* Represents a field parameter literal. */
interface FieldDefinitionParameterLiteral {

	/* The name which is used internally to store and load field parameter values. */
	def String getName()

	/* Represents the title of the field parameter literal which is used in the user interface. */
	def String getTitle()
}

/* Represents the possible field parameter types. */
enum FieldDefinitionParameterType {

	/* A field parameter of the type boolean is backed by a boolean value and read and write via default Boolean methods. */
	BOOLEAN,

	/* A field parameter of the type enumeration is backed by a String value identifying the literal by name. */
	ENUMERATION,

	/* A field parameter of the type integer is backed by a long value and read and write via default Long methods. */
	INTEGER,

	/* A field parameter of the type decimal is backed by a double value and read and write via default Double methods. */
	DECIMAL,

	/* A field parameter of the type string is backed by a String value and read and write via default String methods. */
	STRING
}
