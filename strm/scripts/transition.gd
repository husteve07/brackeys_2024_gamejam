extends Node2D

@export var next_scene:PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Next Level")
