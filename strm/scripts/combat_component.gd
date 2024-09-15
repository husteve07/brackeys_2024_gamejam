extends Node

#category: UI signals
#Delegates for Energy Bar UI, Signature: float -> desc: current blue/red energy percentage
signal update_blue_energy_gauge(blue_energy: int)
signal update_red_energy_gauge(red_energy: int)
signal skill_activated(skill: Skill)
#default energy amount 
@export var red_energy = 0
@export var max_red_energy = 5
@export var blue_energy = 0
@export var max_blue_energy = 5

var current_skill_ref : Skill
var currently_cd_skill : Dictionary #fuck dynamic typing

var skill_double_blue = preload("res://scenes/Skills/skill_double_blue.tscn")
var skill_double_red = preload("res://scenes/Skills/skill_double_red.tscn")
var skill_hollow_purple = preload("res://scenes/Skills/skill_hollow_purple.tscn")
var skill_timer: Timer

func _ready() -> void: 
	pass


func get_skill_timer(in_skill : Skill):
	if in_skill.get_skill_name() in currently_cd_skill:
		return currently_cd_skill[in_skill.get_skill_name()]
	skill_timer = Timer.new()
	skill_timer.wait_time = in_skill.cool_down_seconds
	skill_timer.one_shot = true
	currently_cd_skill[in_skill.get_skill_name()] = skill_timer
	add_child(skill_timer)
	return skill_timer

func activate_skill(in_skill: Skill, mouse_position: Vector2) -> bool:

	add_child(in_skill);
	var skill_timer = get_skill_timer(in_skill) as Timer;
	if !skill_timer.is_stopped():
		print(in_skill.get_skill_name() + " is on cooldown: " + str(skill_timer.time_left))
		#print(currently_cd_skill)
		in_skill.queue_free()
		return false	
	if !in_skill.activate(mouse_position):
		in_skill.queue_free();
		return false
	if !has_enough_energy_to_activate(in_skill):
		print("not enough energy")
		in_skill.queue_free()
		return false;	
	skill_timer.start()
	#print(currently_cd_skill)
	skill_activated.emit(in_skill);
	return true
	


#Factory that produces a Skill object given my combo
#Input: Array[String], command buffer, each element should be either 'red' or 'blue'
#Returns: an Instantiated Skill scene object
func skill_factory(command) -> Skill:
	match command:
		["red", "red"]:
			return skill_double_blue.instantiate();
		["blue", "blue"]:
			return skill_double_red.instantiate();
		["blue", "red"]:
			return skill_hollow_purple.instantiate();
		["red", "blue"]:
			return skill_hollow_purple.instantiate();
	return null;





#helper function, console logs current energy
func print_energy():
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));

#
func has_enough_energy_to_activate(in_skill : Skill) -> bool:
	match in_skill.get_skill_name():
		"AOE_Skill":
			return try_use_blue_laser_energy(2)
		"Healing_skill":
			return try_use_red_laser_energy(2)
		"Time_Slow_Skill":
			return (try_use_blue_laser_energy(1) && try_use_red_laser_energy(1))
	return false

#*************************<Energy Operations>*******************************
# possible refactor
# Uses red laser energy, subtract energy cost from current energy, broadcasts updated energy to UI delegate
# Input: cost: Int desc: cost of energy used
# Output: Status of this operation: Bool, desc: if updated energy is <0 this operation fails
func try_use_red_laser_energy(cost: int) -> bool:
	if(red_energy - cost >= 0):
		red_energy -= cost;
		#UI delegate: Red energy update red energy gauge
		update_red_energy_gauge.emit(red_energy)
		return true;
	return false;
	
	
func try_use_blue_laser_energy(cost: int) -> bool:
	if(blue_energy - cost >= 0):
		blue_energy -= cost;
		#UI delegate: Blue energy update red energy gauge
		update_blue_energy_gauge.emit(blue_energy)
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
		update_blue_energy_gauge.emit(blue_energy)
	else:
		red_energy += 1;
		red_energy = clampi(red_energy, 0, max_red_energy)
		update_red_energy_gauge.emit(red_energy)
		
	print("current Energy: blue: " + str(blue_energy) + " red: " + str(red_energy));
#****************************</Energy Operations>******************************
