extends CharacterBody3D

@onready var animator := $AnimationPlayer
@onready var shooting_timer := $ShootingTimer

var player

var rotation_z
var rotation_x

func _ready():
	rotation_z = global_rotation.z
	rotation_x = global_rotation.x


func _physics_process(delta):
	
	if player != null:
		look_at(player.global_position, Vector3(0,2,0), true)
		global_rotation = Vector3(rotation_x, global_rotation.y, rotation_z)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	move_and_slide()


func prepare_to_shoot() -> void:
	animator.play("shoot")
	shooting_timer.start()


func _on_player_checker_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player = body
		prepare_to_shoot()


func _on_enemy_hp_damage():
	player = PlayerData.player
	prepare_to_shoot()


func _on_enemy_hp_death():
	$BodyCollision.set_deferred("disabled", true)
	$ShootingTimer.stop()
	$AnimationPlayer.play("death")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
