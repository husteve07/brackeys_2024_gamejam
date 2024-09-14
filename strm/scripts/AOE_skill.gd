extends Skill

@export var skill_last_duration = 1.5

var skill_duration_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	skill_duration_timer = Timer.new();
	skill_duration_timer.wait_time = skill_last_duration;
	skill_duration_timer.one_shot = true;
	skill_duration_timer.connect("timeout", Callable(self, "on_skill_timeout"))
	add_child(skill_duration_timer);
	pass # Replace with function body.


func on_skill_timeout():
	print(get_skill_name() + " skill ended")
	queue_free()

func activate(mouse_position):
	#spawn vfx
	skill_duration_timer.start();
	return super.activate(mouse_position);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
