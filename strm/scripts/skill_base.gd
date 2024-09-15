extends Node2D
class_name Skill
@export var skill_name = ""
@export var cool_down_seconds = 0
@export var skill_damage = 50

var tilemap: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_nodes_in_group("room")[0]

func set_skill_activatable():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
#dummy activate function
func activate(mouse_position: Vector2):
	print(str(mouse_position))
	print("activating" + get_skill_name())
	position = mouse_position
	var tile_mouse_pos = tilemap.local_to_map(mouse_position)
	var tile = tilemap.get_cell_tile_data(tile_mouse_pos)
	if tile:
		if tile.get_custom_data("target"):
			return true
	return false
	

#helper func
func get_skill_name() -> String:
	return skill_name
