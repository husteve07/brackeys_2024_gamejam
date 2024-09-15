extends Node

#*****************<Health signals>*******************
signal update_health(current_health_percentage: float)
signal dead
#*****************</Health signals>********************\

#Health component attributes
@export var current_health = 100
@export var max_health = 100
@export var health_regen_countdown = 5;
@export var health_regen_amount = 20
@export var iframe_time = 1;

var health_timer: Timer
var flash_timer: Timer
var i_frame_timer: Timer
var current_shader_shit = 0
var can_take_damage = true

func _ready() -> void:
	health_timer = Timer.new()
	health_timer.wait_time = health_regen_countdown
	health_timer.connect("timeout", Callable(self, "on_health_regen_countdown_finish"))
	#health_timer.one_shot = true
	add_child(health_timer);
	
	flash_timer = Timer.new()
	flash_timer.wait_time = 0.05
	flash_timer.connect("timeout", Callable(self, "flash"))
	add_child(flash_timer);
	
	i_frame_timer = Timer.new()
	i_frame_timer.wait_time = iframe_time
	i_frame_timer.connect("timeout", Callable(self, "on_i_frame_time_out"))
	i_frame_timer.one_shot = true
	add_child(i_frame_timer);
	pass


func start_i_frame_timer():
	i_frame_timer.start();
	print('start i frame')
	flash_timer.start()
	print('start flashing')


func on_i_frame_time_out():
	flash_timer.stop()
	print('stop');	
	if(get_parent() as Player):
		get_parent().get_node("Animation Component").material.set_shader_parameter("flash_modifier", 0)
		can_take_damage = true
		print('iframe over')


func on_health_regen_countdown_finish():
	print("good job: old health: " + str(current_health));
	current_health = clampi(current_health + health_regen_amount, 0, max_health)
	update_health.emit(current_health);
	print("\t\t\tnew health: " + str(current_health))

# takes Damage
# Input: damage taken: int
# desc: upon player taking damage, update_health signal is fired containign the new 
# 		Health percentage for UI update, if the player is dead(current_health == 0)
#		then the dead signal is also fired
func take_damage(damage: int):
	#update UI 
	#if(get_parent() as Player):
		#get_parent().get_node("Animation Component").material.set_shader_parameter("flash_modifier", 1)
	if(!can_take_damage):
		print('damage_negated')
		return;

	start_i_frame_timer()
	current_health = clampi(current_health  - damage, 0, max_health)
	update_health.emit(current_health);
	if(get_parent() as Player):
		health_timer.start()
	can_take_damage = false;
	#print("current Health: " + str(current_health))
	if current_health == 0:
		dead.emit();
	
		
func flash():
	if(get_parent() as Player):
		if(current_shader_shit == 1):
			get_parent().get_node("Animation Component").material.set_shader_parameter("flash_modifier", 0)
			current_shader_shit = 0
		else:
			get_parent().get_node("Animation Component").material.set_shader_parameter("flash_modifier", 1)
			current_shader_shit = 1

	
func player_restore_health(restored_health):
	current_health = clampi(current_health + restored_health, 0, max_health)
	update_health.emit(current_health);
	#print("current Health: " + str(current_health))
