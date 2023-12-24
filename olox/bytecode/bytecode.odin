package bytecode
import "../value"
import "core:fmt"

OpCode :: enum u8 {
	OP_RETURN,
}

Chunk :: struct {
	code:      [dynamic]OpCode,
	constants: value.ValueArray,
}

write_chunk :: proc(chunk: ^Chunk, opcode: OpCode) {
	append(&chunk.code, opcode)
}

free_chunk :: proc(chunk: ^Chunk) {
	delete(chunk.code)
	delete(chunk.constants)
}
