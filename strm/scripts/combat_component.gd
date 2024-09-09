extends Node

@export var red_energy = 0
@export var max_red_energy = 5
@export var blue_energy = 0
@export var max_blue_energy = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func receive_laser_energy(receive_laser: Laser):
	if receive_laser.get_laser_name() == "BlueLaser":
		blue_energy += 1;
		blue_energy = clampi(blue_energy, 0, max_blue_energy)
		print("blue energy: " + str(blue_energy))
	else:
		red_energy += 1;
		red_energy = clampi(red_energy, 0, max_red_energy)
		print("red energy: " + str(red_energy))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
