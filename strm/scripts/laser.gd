extends Node2D
class_name Laser

# Velocity of the laser
@export var speed = 350
@export var laser_name = "laser"
@export var damage = 0
var player_ref: Player
var time_slowed= 0 ;
var bullet_slow_timer;
static var slowed_coeff = 1;
static var slowed_time = 0;
var direction = Vector2.ZERO
var spawned_while_skill_is_active = false;

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered_player)
	player_ref = get_tree().get_nodes_in_group("player")[0]
	player_ref.activated_skill.connect(on_player_activate_skills);
	player_ref.get_node("HealthComponent").dead.connect(on_reset)
	bullet_slow_timer = Timer.new()

	if(spawned_while_skill_is_active):
		bullet_slow_timer.wait_time = slowed_time;
		bullet_slow_timer.connect("timeout", Callable(self, "on_slow_time_end"));
		bullet_slow_timer.one_shot = true
		speed *= slowed_coeff
		add_child(bullet_slow_timer)
		bullet_slow_timer.start()


func on_player_activate_skills(skill : Skill):
	var time_slow_skill = skill as TimeSlow
	if time_slow_skill :
		speed *= time_slow_skill.slow_coeff
		slowed_coeff = time_slow_skill.slow_coeff
		slowed_time = skill.time_slow_time
		bullet_slow_timer.wait_time = skill.time_slow_time;
		bullet_slow_timer.connect("timeout", Callable(self, "on_slow_time_end"));
		bullet_slow_timer.one_shot = true
		add_child(bullet_slow_timer)
		bullet_slow_timer.start()
	

func on_slow_time_end():
	speed /= slowed_coeff
	slowed_time = 0
	

# possible refactory
#if the laser collides with player, destroy laser
func on_area_entered_player(other_area:Area2D):
	if !other_area.get_collision_layer_value(1):
		return
	queue_free()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()

func on_reset():
	queue_free()
	
func _process(delta):
	position += direction * speed * delta

	# Destroy the laser when it goes off-screen or out of bounds
	#if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		#queue_free()

#*****************<helper functions>*****************
func get_laser_name():
	return laser_name
	

func get_laser_damage():
	return damage
#*****************</helper functions>*****************
