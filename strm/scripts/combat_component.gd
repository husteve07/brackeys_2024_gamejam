extends Node

signal update_blue_energy_gauge(blue_energy_percentage: float)
signal update_red_energy_gauge(red_energy_percentage: float)

@export var red_energy = 0
@export var max_red_energy = 5
@export var blue_energy = 0
@export var max_blue_energy = 5


var skill_double_blue = preload("res://scenes/Skills/skill_double_blue.tscn")
var skill_double_red = preload("res://scenes/Skills/skill_double_red.tscn")
var skill_hollow_purple = preload("res://scenes/Skills/skill_hollow_purple.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func skill_factory(command) -> Skill:
	match command:
		["red", "red"]:
			if(!use_red_laser_energy(2)):
				print("not enough red energy")
				return null;
			return skill_double_red.instantiate();
		["blue", "blue"]:
			if(!use_blue_laser_energy(2)):
				print("not enough blue energy")
				return null;
			return skill_double_blue.instantiate();
		["blue", "red"]:
			if !(use_blue_laser_energy(5) && use_red_laser_energy(5)):
				print("not enough blue or red energy")
				return;
			return skill_hollow_purple.instantiate();
		["red", "blue"]:
			if !(use_blue_laser_energy(5) && use_red_laser_energy(5)):
				print("not enough blue or red energy")
				return;
			return skill_hollow_purple.instantiate();

	return null;


func print_energy():
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));


func use_red_laser_energy(cost: int) -> bool:
	if(red_energy - cost >= 0):
		red_energy -= cost;
		#update_red_energy_gauge.emit(clampi(red_energy/max_red_energy, 0, max_red_energy))
		return true;
	return false;


func use_blue_laser_energy(cost: int) -> bool:
	if(blue_energy - cost >= 0):
		blue_energy -= cost;
		#update_blue_energy_gauge.emit(clampi(blue_energy/max_blue_energy, 0, max_blue_energy))
		return true;
	return false;


func receive_laser_energy(receive_laser: Laser):
	if receive_laser.get_laser_name() == "BlueLaser":
		blue_energy += 1;
		blue_energy = clampi(blue_energy, 0, max_blue_energy)
		#update_blue_energy_gauge.emit(clampi(blue_energy/max_blue_energy, 0, max_blue_energy))
	else:
		red_energy += 1;
		red_energy = clampi(red_energy, 0, max_red_energy)
		#update_red_energy_gauge.emit(clampi(red_energy/max_red_energy, 0, max_red_energy))
		
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
