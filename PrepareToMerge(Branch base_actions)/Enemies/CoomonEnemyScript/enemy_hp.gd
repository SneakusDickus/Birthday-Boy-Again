extends Node3D

@export var enemy_hp: int


signal damage
signal death


func get_damage(damage: int):
	enemy_hp -= damage
	emit_signal("damage")
	if enemy_hp <= 0:
		emit_signal("death")
		$EnemyTorso/torso.set_deferred("disabled", true)
		$EnemyHead/head.set_deferred("disabled", true)
