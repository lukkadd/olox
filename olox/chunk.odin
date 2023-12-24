package olox
import "core:fmt"

OpCode :: enum u8 {
	OP_CONSTANT,
	OP_RETURN,
}

ByteCode :: union {
	u8,
	OpCode,
}

Chunk :: struct {
	code:      [dynamic]ByteCode,
	constants: ValueArray,
}

write_chunk :: proc(chunk: ^Chunk, byte_: ByteCode) {
	append(&chunk.code, byte_)
}

free_chunk :: proc(chunk: ^Chunk) {
	delete(chunk.code)
	delete(chunk.constants)
}

add_constant :: proc(chunk: ^Chunk, value: Value) -> int {
	write_value_array(&chunk.constants, value)
	return len(chunk.constants) - 1
}
