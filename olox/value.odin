package olox

import "core:fmt"

Value :: f64

ValueArray :: [dynamic]Value

write_value_array :: proc(array: ^ValueArray, value: Value) {
	append(array, value)
}

print_value :: proc(value: Value) {
	fmt.printf("%g", value)
}
