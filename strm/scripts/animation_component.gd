extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var anim_tree: AnimationTree = $AnimationTree

var facing:int = 1

#Mostly temporary animation tree code
func _process(delta: float) -> void:
	if player.velocity.x > 0:
		facing = 1
	if player.velocity.x < 0:
		facing = -1
	blend(facing)
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		anim_tree.set("parameters/Transition/transition_request", "run")
	if Input.is_action_just_pressed("absorb_laser"):
		anim_tree.set("parameters/Transition 2/transition_request", "shield")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if Input.is_action_just_pressed("blue_skill"):
		anim_tree.set("parameters/Transition 2/transition_request", "skill")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if Input.is_action_just_pressed("red_skill"):
		anim_tree.set("parameters/Transition 2/transition_request", "skill")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if player.velocity==Vector2.ZERO:
		anim_tree.set("parameters/Transition/transition_request", "idle")

func blend(facing):
	anim_tree.set("parameters/idle/blend_position", facing)
	anim_tree.set("parameters/run/blend_position", facing)
	anim_tree.set("parameters/shield/blend_position", facing)
	anim_tree.set("parameters/skill/blend_position", facing)
