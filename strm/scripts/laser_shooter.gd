extends CharacterBody2D
class_name LaserShooter

signal on_slow_is_active(slow_duration, slow_coefficient)
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const ENEMY_LASER = preload("res://assets/sounds/enemy_laser.ogg")
const ROBOT_DAMAGED = preload("res://assets/sounds/robot-damaged.ogg")
const ROBOT_EXPLODE = preload("res://assets/sounds/robot_explode.ogg")
const ROBOT_NOISE = preload("res://assets/sounds/robot_noise.ogg")

@export var firing_time_interval = 2.0
@export var invincible_time = 1.0
@export var character_slow_coeff = 0.25

@onready var shadow: Sprite2D = $Shadow
@onready var head: AnimatedSprite2D = $Head
@onready var body: AnimatedSprite2D = $Body

# Preload the red and purple laser scenes
var RedLaserScene = preload("res://scenes/Lasers/red_laser.tscn")
var BlueLaserScene = preload("res://scenes/Lasers/blue_laser.tscn")
var player:Node2D
var gate:Node2D
var invincibility_timer : Timer
var spawn_slow_laser_count_down : Timer
var is_time_slow_active = false
var skill_ref : TimeSlow
var laser_spawn_timer: Timer
var reset_position
var active = true
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.active = false
	reset_position = position
	#Spawn a laser every 2 seconds
	$HitBox.area_entered.connect(on_entered_player_skill)
	$HealthComponent.dead.connect(on_dead);
	player = get_tree().get_nodes_in_group("player")[0]
	player.activated_skill.connect(on_player_time_slow_activated);
	player.get_node("HealthComponent").dead.connect(on_reset)
	laser_spawn_timer = Timer.new()
	#invincibility_timer = Timer.new()
	laser_spawn_timer.wait_time = firing_time_interval
	laser_spawn_timer.connect("timeout", Callable(self, "spawn_laser"))
	add_child(laser_spawn_timer)
	laser_spawn_timer.start()

func restore_laser_speed():
	is_time_slow_active = false;
	

func on_player_time_slow_activated(in_skill : Skill):
	if in_skill as TimeSlow:
		
		skill_ref = in_skill
		spawn_slow_laser_count_down = Timer.new()
		spawn_slow_laser_count_down.one_shot = true;
		spawn_slow_laser_count_down.wait_time = in_skill.time_slow_time
		spawn_slow_laser_count_down.connect("timeout", Callable(self, "restore_laser_speed"));
		add_child(spawn_slow_laser_count_down)
		is_time_slow_active = true
		on_slow_is_active.emit(in_skill.time_slow_time, character_slow_coeff)
		spawn_slow_laser_count_down.start();
	
	
func set_invincibility_timer():
	invincibility_timer = Timer.new()
	invincibility_timer.wait_time = invincible_time
	invincibility_timer.connect("timeout", Callable(self, "reset_take_damage"))
	invincibility_timer.one_shot = true;
	add_child(invincibility_timer)
	
func reset_take_damage():
	var skill_effects  = []
	if $HitBox.get_overlapping_areas().size() == 0:
		print("enemy left zone")
		return;
	print("enemy still in zone")
	for area in $HitBox.get_overlapping_areas():
		if area.get_parent() as Skill:
			skill_effects.append(area.get_parent())
			
	var damage = 0
	for skill in skill_effects:
		damage += skill.skill_damage
	print(damage)
		
	$HealthComponent.take_damage(damage);
	if $HealthComponent.current_health > 0: 
		audio_stream_player.stream = ROBOT_DAMAGED
		audio_stream_player.play()
	invincibility_timer.start() 
			

func on_entered_player_skill(other_area: Area2D):
	var player_skill = other_area.get_parent() as Skill;
	if !invincibility_timer:
		set_invincibility_timer()
	if player_skill:
		var damage = other_area.get_parent().skill_damage 
		if damage > 0:
			$HealthComponent.take_damage(other_area.get_parent().skill_damage);
			if($HealthComponent.current_health > 0):
				invincibility_timer.start()
	

func on_dead():
	#play death animation
	invincibility_timer.stop()
	print("enemy death")
	shadow.visible = false
	animation_player.active = true
	animation_player.play("die")
	active = false
	get_parent().defeated += 1
	audio_stream_player
	audio_stream_player.stream = ROBOT_EXPLODE
	audio_stream_player.volume_db = -4
	audio_stream_player.play()
	pass

func on_reset():
	animation_player.stop()
	animation_player.play("alive")
	animation_player.active = false
	active = true
	position = reset_position
	laser_spawn_timer.start()
	get_parent().defeated -= 1
	$HealthComponent.player_restore_health($HealthComponent.max_health)
	pass

func _process(delta):
	if player.position.y > position.y:
		z_index = 0
	else:
		z_index = 2
	if player.position.x > position.x:
		head.scale.x=-1
		body.scale.x=-1
	else:
		head.scale.x = 1
		body.scale.x= 1

#desc: aquires player location and fires laser towards it
func spawn_laser():
	if player:
		if active:
			# Calculate the direction to the player
			var direction = (player.position - position).normalized()
			var laser_instance = choose_laser_type();
			if laser_instance == null:
				return
			
			
			# Set position and direction
			laser_instance.position = position + (4*direction)
			laser_instance.direction = direction  
			
			laser_instance.spawned_while_skill_is_active = is_time_slow_active
			
			
			# Add the laser to the scene tree
			get_parent().add_child(laser_instance)

			laser_instance.audio_stream_player.play()

func choose_laser_type() -> Laser:
	# Randomly choose between red and blue laser
	if randi() % 2 == 0:
		return RedLaserScene.instantiate()
	else:
		return BlueLaserScene.instantiate()
