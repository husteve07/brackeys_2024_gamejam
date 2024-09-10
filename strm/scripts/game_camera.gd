extends Camera2D

var target_position = Vector2.ZERO

# makes current camera the default cam
func _ready() -> void:
	make_current();



func _process(delta: float) -> void:
	aquire_target()
	#camera smoothing, framerate ind. lerping
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 15));


#aquire player position
func aquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position;
	
