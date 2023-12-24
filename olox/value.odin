package olox

Value :: f64

ValueArray :: [dynamic]Value

write_value_array :: proc(array: ^ValueArray, value: Value) {
	append(array, value)
}
