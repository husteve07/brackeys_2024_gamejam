extends Skill
class_name TimeSlow
@export var time_slow_time = 0.0
@export var slow_coeff = .25
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	var time_finished = Timer.new();
	time_finished.wait_time = time_slow_time;
	time_finished.one_shot = true;
	time_finished.connect("timeout", Callable(self,"on_time_finished"));
	add_child(time_finished);
	time_finished.start()


func on_time_finished():
	skill_sfx.stop();
