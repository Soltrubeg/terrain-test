extends Node

@export var gridmap: GridMap
@export var map_size: Vector2 = Vector2(150, 150)
@export_range(0.001, 1.0, 0.001) var noise_frequency := 0.015
@export_range(0.0, 10.0, 0.1) var island_falloff_strength := 2.5
@export_range(0.0, 100.0, 0.1) var max_height := 10.0
@export var terrain_threshold := 0.0

# IDs for GridMap mesh items (make sure they match your tileset)
const TILE_STONE := 0

func _ready():
	randomize()
	generate_world(randi())

func generate_world(seed: int) -> void:
	Global.seed=seed
	var noise = FastNoiseLite.new()
	noise.seed = seed
	noise.frequency = noise_frequency
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	var half_size = map_size / 2

	for x in range(-half_size.x, half_size.x):
		for z in range(-half_size.y, half_size.y):
			var world_pos = Vector2(x, z)
			var normalized_pos = (world_pos + half_size) / map_size * 2.0 - Vector2.ONE
			var island_falloff = calculate_island_falloff(normalized_pos)
			var raw_noise = noise.get_noise_2d(x, z)
			var height_value = raw_noise * island_falloff

			var terrain_height = int(floor(height_value * max_height))

			# Optional: create base layer (like underwater terrain)
			var tile_type = TILE_STONE

			for y in range(0, abs(terrain_height)):
				gridmap.set_cell_item(Vector3i(x, y, z), tile_type)

func calculate_island_falloff(normalized_pos: Vector2) -> float:
	var distance = max(abs(normalized_pos.x), abs(normalized_pos.y))
	var falloff = pow(distance, island_falloff_strength)
	return clamp(1.0 - falloff, 0.0, 1.0)
