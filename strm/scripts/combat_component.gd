extends Node

#category: UI signals
#Delegates for Energy Bar UI, Signature: float -> desc: current blue/red energy percentage
signal update_blue_energy_gauge(blue_energy_percentage: float)
signal update_red_energy_gauge(red_energy_percentage: float)

#default energy amount 
@export var red_energy = 0
@export var max_red_energy = 5
@export var blue_energy = 0
@export var max_blue_energy = 5


var skill_double_blue = preload("res://scenes/Skills/skill_double_blue.tscn")
var skill_double_red = preload("res://scenes/Skills/skill_double_red.tscn")
var skill_hollow_purple = preload("res://scenes/Skills/skill_hollow_purple.tscn")


#Factory that produces a Skill object given my combo
#Input: Array[String], command buffer, each element should be either 'red' or 'blue'
#Returns: an Instantiated Skill scene object
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


#helper function, console logs current energy
func print_energy():
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));

#*************************<Energy Operations>*******************************
# possible refactor
# Uses red laser energy, subtract energy cost from current energy, broadcasts updated energy to UI delegate
# Input: cost: Int desc: cost of energy used
# Output: Status of this operation: Bool, desc: if updated energy is <0 this operation fails
func use_red_laser_energy(cost: int) -> bool:
	if(red_energy - cost >= 0):
		red_energy -= cost;
		#UI delegate: Red energy update red energy gauge
		update_red_energy_gauge.emit(clampi(red_energy/max_red_energy, 0, max_red_energy))
		return true;
	return false;
	
	
func use_blue_laser_energy(cost: int) -> bool:
	if(blue_energy - cost >= 0):
		blue_energy -= cost;
		#UI delegate: Blue energy update red energy gauge
		update_blue_energy_gauge.emit(clampi(blue_energy/max_blue_energy, 0, max_blue_energy))
		return true;
	return false;


#istg I was prolly high when I wrote this
#Recieves energy, BroadCasts updated energy on UI delegates
#add 1 energy (clamped) to the laser gauge type specified
# Input: receive_laser: Laser_sceneObject, desc: laser gauge type to add to
func receive_laser_energy(receive_laser: Laser): #should return bool
	if receive_laser.get_laser_name() == "BlueLaser":
		blue_energy += 1;
		blue_energy = clampi(blue_energy, 0, max_blue_energy)
		update_blue_energy_gauge.emit(clampi(blue_energy/max_blue_energy, 0, max_blue_energy))
	else:
		red_energy += 1;
		red_energy = clampi(red_energy, 0, max_red_energy)
		update_red_energy_gauge.emit(clampi(red_energy/max_red_energy, 0, max_red_energy))
		
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));
#****************************</Energy Operations>******************************
