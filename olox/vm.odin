package olox

import "core:fmt"
import "core:mem"

VM :: struct {
	chunk: ^Chunk,
	ip:    ^u8,
}

InterpretResult :: enum {
	INTERPRET_OK,
	INTERPRET_COMPILE_ERROR,
	INTERPRET_RUNTIME_ERROR,
}

//Global static 
vm: VM

init_vm :: proc() {

}

free_vm :: proc() {

}

interpret :: proc(chunk: ^Chunk) -> InterpretResult {
	vm.chunk = chunk
	vm.ip = &vm.chunk.code[0]
	return run()
}

run :: proc() -> InterpretResult {
	for {

		when DEBUG_TRACE_EXECUTION {
			disassembleInstruction(vm.chunk, int(mem.ptr_sub(vm.ip, &vm.chunk.code[0])))
		}

		//odin doesn't have pointer arrithmetics, to this is the best i could do
		instruction: OpCode = OpCode(vm.ip^)
		vm.ip = mem.ptr_offset(vm.ip, 1)

		#partial switch (instruction) {
		case .OP_RETURN:
			return InterpretResult.INTERPRET_OK
		case .OP_CONSTANT:
			constant: Value = vm.chunk.constants[vm.ip^]
			vm.ip = mem.ptr_offset(vm.ip, 1)
			print_value(constant)
			fmt.printf("\n")

		}
	}
}
