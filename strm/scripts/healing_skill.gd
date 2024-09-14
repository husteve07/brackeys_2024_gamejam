extends Skill
var player_ref : Player
var direction
var should_dash = false
var dash_time = .25
var dash_timer : Timer
var og_velocity
var og_direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	player_ref = get_tree().get_nodes_in_group("player")[0]
	og_velocity = player_ref.velocity
	dash_timer = Timer.new()
	dash_timer.wait_time = dash_time
	dash_timer.one_shot = true
	dash_timer.connect("timeout", Callable(self, "on_dash_timer_finished"))
	pass # Replace with function body.


func on_dash_timer_finished():
	player_ref.velocity = og_velocity
	should_dash = false

func activate(mouse_position: Vector2):

	og_velocity = player_ref.velocity;
	direction = (mouse_position - player_ref.position).normalized()
	dash_timer.start()
	should_dash = true

	return true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if should_dash:
		player_ref.velocity = direction * 1000;
		player_ref.move_and_slide()
	pass
