extends Node

signal taken_damage(damage: int)
signal dead

@export var current_health = 100
@export var max_health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(damage: int):
	#update UI taken_damage.emit(damage);
	current_health = clampi(current_health  - damage, 0, max_health)
	print("current Health: " + str(current_health))
	if current_health == 0:
		dead.emit();
