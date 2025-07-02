extends Node3D

@export var enemy_hp: int
@export var enemy_torso_area: Area3D
@export var enemy_head_area: Area3D

signal damage
signal death


func _ready():
	enemy_torso_area.connect("ray_detect", _on_detect_torso)
	enemy_head_area.connect("ray_detect", _on_detect_head)


func _on_detect_torso():
	get_damage(PlayerData.damage)


func _on_detect_head():
	get_damage(PlayerData.damage*2)


func get_damage(damage: int):
	enemy_hp -= damage
	if enemy_hp <= 0:
		emit_signal("death")
	else:
		emit_signal("damage")
