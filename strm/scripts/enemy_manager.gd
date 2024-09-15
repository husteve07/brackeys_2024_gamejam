extends Node2D

@export var gate_threshold = 5
var defeated:int = 0

func _process(delta: float) -> void:
	if defeated >= gate_threshold:
		print("deleted")
		queue_free()
