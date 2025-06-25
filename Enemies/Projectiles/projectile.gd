extends CharacterBody3D

func _physics_process(delta):
	move_and_slide()

func _on_area_3d_body_entered(body):
	queue_free()
