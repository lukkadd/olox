package olox

import "core:fmt"
import "core:mem"

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	init_vm()
	defer free_vm()

	chunk := Chunk{}
	defer free_chunk(&chunk)

	write_constant(&chunk, 123.2, 12)
	write_constant(&chunk, 33.2, 12)
	write_constant(&chunk, 99, 12)
	write_constant(&chunk, 99, 12)
	write_constant(&chunk, 99, 12)
	write_constant(&chunk, 99, 545)
	write_constant(&chunk, 99, 12)
	write_constant(&chunk, 99, 12)
	write_chunk(&chunk, OpCode.OP_RETURN, 12)
	write_chunk(&chunk, OpCode.OP_RETURN, 12)
	write_chunk(&chunk, OpCode.OP_RETURN, 23)

	// disassembleChunk(&chunk, "test chunk")
	interpret(&chunk)
}
