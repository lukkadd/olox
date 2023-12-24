package bytecode
import "core:fmt"

OpCode :: enum u8 {
	OP_RETURN,
}

Chunk :: [dynamic]OpCode
