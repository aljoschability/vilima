package com.aljoschability.vilima.fields

/* Represents the possible field parameter types. */
enum FieldParameterType {

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
