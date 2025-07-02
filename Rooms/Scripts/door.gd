extends Node3D

@onready var animator := $AnimationPlayer

var is_open := false

func door_open() -> void:
	if is_open: return
	animator.play("open")
	is_open = true


func door_close() -> void:
	if !is_open: return
	animator.play("close")
	is_open = false
