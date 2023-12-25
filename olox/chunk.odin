package olox
import "core:fmt"

OpCode :: enum u8 {
	OP_CONSTANT,
	OP_CONSTANT_LONG,
	OP_RETURN,
}

ByteCode :: union {
	u8,
	OpCode,
}

LineRLE :: struct {
	lineNumber: int,
	count:      int,
}

Chunk :: struct {
	code:      [dynamic]u8,
	constants: ValueArray,
	lines:     [dynamic]LineRLE,
}

write_chunk :: proc(chunk: ^Chunk, byte_: ByteCode, line: int) {
	new_byte: u8
	switch t in byte_ {
	case u8:
		new_byte = t
	case OpCode:
		new_byte = u8(t)

	}
	append(&chunk.code, new_byte)

	if len(chunk.lines) == 0 || line != chunk.lines[len(chunk.lines) - 1].lineNumber {
		append(&chunk.lines, LineRLE{line, 1})
	} else {
		chunk.lines[len(chunk.lines) - 1].count += 1
	}
}

free_chunk :: proc(chunk: ^Chunk) {
	delete(chunk.code)
	delete(chunk.constants)
	delete(chunk.lines)
}

add_constant :: proc(chunk: ^Chunk, value: Value) -> int {
	write_value_array(&chunk.constants, value)
	return len(chunk.constants) - 1
}

write_constant :: proc(chunk: ^Chunk, value: Value, line: int) {
	index: int = add_constant(chunk, value)
	if index < 256 {
		write_chunk(chunk, OpCode.OP_CONSTANT, line)
		write_chunk(chunk, u8(index), line)
	} else {
		write_chunk(chunk, OpCode.OP_CONSTANT_LONG, line)
		write_chunk(chunk, u8(index & 0xff), line)
		write_chunk(chunk, u8(index >> 8 & 0xff), line)
		write_chunk(chunk, u8(index >> 16 & 0xff), line)
	}
}
