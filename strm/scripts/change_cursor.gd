extends Node2D

var cursor = preload("res://assets/cursor.png")

func _input(event):
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(32,32))
