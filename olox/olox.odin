package olox

import "bytecode"
import "core:fmt"
import "debug"

main :: proc() {
	fmt.println("Hello")

	chunk := make(bytecode.Chunk, 0, 0)
	defer delete(chunk)

	debug.disassembleChunk(&chunk, "test chunk")
}
