extends CharacterBody2D
class_name Player

signal activated_skill(skill: Skill)

@export var parry_cool_down = 1;

var can_use_parry = true;
var parry_cooldown_timer = Timer.new();
const MAX_SPEED = 225
var skill_buffer = []
var reset_position = Vector2.ZERO

# Construct necessary components, setup signal callbacks and timers
func _ready() -> void:
	reset_position = position
	$PlayerHitBox.area_entered.connect(on_hitbox_entered)
	$HealthComponent.dead.connect(on_death)
	setup_parry_cd_timer()
	add_child(parry_cooldown_timer);

#***********************<Movement>***********************
# grab user input and move player
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction*MAX_SPEED
	move_and_slide()
	
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
#***********************</Movement>***********************


#***********************<Timer Setup>***********************
#Setup Parry cool down Timer, cooldown value exposed to inspector 
func setup_parry_cd_timer():
	parry_cooldown_timer.autostart = false;
	parry_cooldown_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	parry_cooldown_timer.wait_time = parry_cool_down;

func _on_timer_timeout():
	can_use_parry = true;
#***********************</Timer Setup>***********************


#***********************<Collision>**************************
# PlayerHitBox Collision callback 
# checks if colliding body is type laser, if so, tell the health component
# damage has been taken
func on_hitbox_entered(other_area: Area2D):
	var colliding_laser = other_area.get_parent() as Laser
	if colliding_laser == null:
		return
	$HealthComponent.take_damage(colliding_laser.damage)

# possible refactor
# stores all the Laser type objects within the ParryBox inside an array
# then passes each laser to the receive_laser_energy function in combatcomponent for
# energy management
func absorb_all_lasers_inside_parrybox():
	var parrying_lasers_area = $ParryBox.get_overlapping_areas() as Array[Area2D];
	
	for laser_area in parrying_lasers_area:
		var laser = laser_area.get_parent() as Laser;
		if laser == null:
			return
		$CombatComponent.receive_laser_energy(laser);
		laser.queue_free();
#***********************</Collision>**************************


#***********************<Mouse & Key input>*******************
#upon RMB pressed:
#	if parry is on cd, early return
#	else absorbs laser energy
#	start parry cd timer

#upon LMB pressed:
#	try activating skill
#	clears skill input buffer

func handle_mouse_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !can_use_parry:
				#print("parry on cooldown")
				return;
			absorb_all_lasers_inside_parrybox();
			can_use_parry = false;
			parry_cooldown_timer.start();
			#print("parrying");
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			if(try_activate_skill(get_global_mouse_position())):
				skill_buffer.clear();	
				$CombatComponent.print_energy();
					
#possible refactor
#Keyboard skill input
#	if left shift or space bar is pressed:
#	insert corresponding command to command buffer
#   if the array has more than 3 elements:
#		chop off everything after the second element

func handle_keyboard_skill_input(event):
	if Input.is_action_just_pressed("red_skill"):
		skill_buffer.insert(0, "red")
		if(skill_buffer.size() > 2):
			skill_buffer = skill_buffer.slice(0,2);
		#print(skill_buffer);


	if Input.is_action_just_pressed("blue_skill"):
		skill_buffer.insert(0, "blue")
		if(skill_buffer.size() > 2):
			skill_buffer = skill_buffer.slice(0,2);
		#print(skill_buffer);


func _input(event):
	handle_mouse_input(event);
	handle_keyboard_skill_input(event);
#***********************</Mouse & Key input>*******************	
	

	
#***********************<Gameplay>*******************
# tries to activate skill with the current command buffer		
# if the command buffer is size 2:
#	instantiate the skill using the skill factory, by passing in the command buffer
#	activate the skill
func try_activate_skill(mouse_position : Vector2) -> bool:
	if skill_buffer.size() != 2:
		print("skill buffer not full");
		return false;
	var skill_instance = $CombatComponent.skill_factory(skill_buffer) as Skill
	if skill_instance == null:
		#print('skill instance null')
		return false;
		
	activated_skill.emit(skill_instance);
	return $CombatComponent.activate_skill(skill_instance, mouse_position);

func on_death():
	print("player dead")
	position = reset_position;
#***********************</Gameplay>*******************		
