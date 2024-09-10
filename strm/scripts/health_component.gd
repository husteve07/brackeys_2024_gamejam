extends Node

#*****************<Health signals>*******************
signal update_health(current_health_percentage: float)
signal dead
#*****************</Health signals>********************

#Health component attributes
@export var current_health = 100
@export var max_health = 100

#takes Damage
func take_damage(damage: int):
	#update UI 
	update_health.emit(clampf(current_health/max_health, 0, max_health));
	current_health = clampi(current_health  - damage, 0, max_health)
	print("current Health: " + str(current_health))
	if current_health == 0:
		dead.emit();
