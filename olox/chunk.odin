package olox
import "core:fmt"

OpCode :: enum u8 {
	OP_RETURN,
}

Chunk :: struct {
	code:      [dynamic]OpCode,
	constants: ValueArray,
}

write_chunk :: proc(chunk: ^Chunk, opcode: OpCode) {
	append(&chunk.code, opcode)
}

free_chunk :: proc(chunk: ^Chunk) {
	delete(chunk.code)
	delete(chunk.constants)
}

add_constant :: proc(chunk: ^Chunk, value: Value) {

}
