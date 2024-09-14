extends Area2D

var flagcheck:int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if flagcheck == 1:
			body.reset_position = position
			flagcheck = 0
