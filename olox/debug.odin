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

	if (offset > 0 && chunk.lines[offset] == chunk.lines[offset - 1]) {
		fmt.printf("   | ")
	} else {
		fmt.printf("%4d ", chunk.lines[offset])
	}

	instruction: OpCode = OpCode(chunk.code[offset])
	switch instruction {
	case .OP_RETURN:
		return simpleInstruction("OP_RETURN", offset)
	case .OP_CONSTANT:
		return constantInstruction("OP_CONSTANT", chunk, offset)
	case .OP_CONSTANT_LONG:
		return constantInstruction("OP_CONSTANT", chunk, offset)
	case:
		fmt.printf("Unknown opcode %d\n", instruction)
		return offset + 1
	}
}

simpleInstruction :: proc(name: string, offset: int) -> int {
	fmt.printf("%s\n", name)
	return offset + 1
}

constantInstruction :: proc(name: string, chunk: ^Chunk, offset: int) -> int {
	constant: u8 = chunk.code[offset + 1]
	fmt.printf("%-16s %4d '", name, constant)
	printValue(chunk.constants[constant])
	fmt.printf("'\n")
	return offset + 2
}

longConstantInstruction :: proc(name: string, chunk: ^Chunk, offset: int) -> int {
	constant: u8 =
		chunk.code[offset + 1] | chunk.code[offset + 2] << 8 | chunk.code[offset + 3] << 16
	fmt.printf("%-16s %4d '", name, constant)
	printValue(chunk.constants[constant])
	fmt.printf("'\n")
	return offset + 4
}
