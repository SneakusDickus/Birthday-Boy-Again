extends Node3D

@onready var animator := $AnimationPlayer

func door_open() -> void:
	animator.play("open")


func door_close() -> void:
	animator.play("close")
