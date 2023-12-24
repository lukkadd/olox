package olox

import "core:fmt"

disassembleChunk :: proc(chunk: ^Chunk, name: string) {
	fmt.printf("== %s ==\n", name)

	for offset := 0; offset < len(chunk.code); {
		offset = disassembleInstruction(chunk, offset)
	}
}
disassembleInstruction :: proc(chunk: ^Chunk, offset: int) -> int {
	fmt.printf("%04d ", offset)

	instruction: OpCode = chunk.code[offset]
	switch instruction {
	case .OP_RETURN:
		return simpleInstruction("OP_RETURN", offset)
	case:
		fmt.printf("Unknown opcode %d\n", instruction)
		return offset + 1
	}
}

simpleInstruction :: proc(name: string, offset: int) -> int {
	fmt.printf("%s\n", name)
	return offset + 1
}
