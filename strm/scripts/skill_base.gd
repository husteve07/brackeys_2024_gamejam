extends Node2D
class_name Skill
@export var skill_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#dummy activate function
func activate()->bool:
	print(get_skill_name() + " Activing")
	return true
	

#helper func
func get_skill_name() -> String:
	return skill_name
