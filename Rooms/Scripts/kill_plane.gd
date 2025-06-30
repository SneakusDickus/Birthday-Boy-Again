extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.emit_signal("get_damage", PlayerData.hp)
