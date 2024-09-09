extends CharacterBody2D

@export var parry_cool_down = 1;

var can_use_parry = true;
var parry_cooldown_timer;
const MAX_SPEED = 200
var skill_buffer = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerHitBox.area_entered.connect(on_hitbox_entered)
	$HealthComponent.dead.connect(on_death)
	parry_cooldown_timer = Timer.new()
	parry_cooldown_timer.autostart = false;
	parry_cooldown_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	parry_cooldown_timer.wait_time = parry_cool_down;
	add_child(parry_cooldown_timer);


func _on_timer_timeout():
	can_use_parry = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction*MAX_SPEED
	move_and_slide()
	


func get_movement_vector():
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func on_hitbox_entered(other_area: Area2D):
	var colliding_laser = other_area.get_parent() as Laser
	if colliding_laser == null:
		return
	$HealthComponent.take_damage(colliding_laser.damage)
	


func handle_mouse_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !can_use_parry:
				print("parry on cooldown")
				return;
			absorb_laser();
			can_use_parry = false;


			parry_cooldown_timer.start();
			print("parrying");
		if event.button_index == MOUSE_BUTTON_LEFT:
			if(try_activate_skill()):
				skill_buffer.clear();	
				$CombatComponent.print_energy();
					
	
	
func handle_keyboard_skill_input(event):
	if Input.is_action_just_pressed("red_skill"):
		skill_buffer.insert(0, "red")
		if(skill_buffer.size() > 2):
			skill_buffer = skill_buffer.slice(0,2);
		print(skill_buffer);


	if Input.is_action_just_pressed("blue_skill"):
		skill_buffer.insert(0, "blue")
		if(skill_buffer.size() > 2):
			skill_buffer = skill_buffer.slice(0,2);
		print(skill_buffer);


func _input(event):
	handle_mouse_input(event);
	handle_keyboard_skill_input(event);
	
	
func reset_cooldown_timer():
	can_use_parry = true;
	
	
func try_activate_skill() -> bool:
	if skill_buffer.size() != 2:
		print("skill buffer not full");
		return false;
	var skill_instance = $CombatComponent.skill_factory(skill_buffer) as Skill
	if skill_instance == null:
		return false;
	print("activating: " + skill_instance.get_skill_name());
	return true;


func absorb_laser():
	var parrying_lasers_area = $ParryBox.get_overlapping_areas() as Array[Area2D];
	
	for laser_area in parrying_lasers_area:
		var laser = laser_area.get_parent() as Laser;
		if laser == null:
			return
		$CombatComponent.receive_laser_energy(laser);
		laser.queue_free();


func on_death():
	print("player dead")
	queue_free();
	get_tree().quit();
