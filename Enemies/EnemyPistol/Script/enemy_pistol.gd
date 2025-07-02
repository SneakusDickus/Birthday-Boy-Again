extends CharacterBody3D

@onready var sounds: Dictionary[String, AudioStreamPlayer3D] = {
	"death" : $Sounds/DeathSound,
	"shoot" : $Sounds/ShootSound,
	"hurt" : $Sounds/HurtSound,
	"spawn" : $Sounds/SpawnSound
}

@onready var animator := $AnimationPlayer
@onready var shooting_timer := $ShootingTimer
@onready var projectile_spawn_point := $metarig_001/Skeleton3D/BoneAttachment3D/Gun/ProjectileSpawnPoint
@onready var projectile_inst := preload("res://Enemies/Projectiles/projectile.tscn")

var player
var is_dead

var rotation_z
var rotation_x

func _ready():
	sounds["spawn"].play()
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
	sounds["hurt"].play()
	player = PlayerData.player
	prepare_to_shoot()


func _on_enemy_hp_death():
	$ShootingTimer.stop()
	sounds["death"].play()
	is_dead = true
	$AnimationPlayer.play("death")
	$BodyCollision.set_deferred("disabled", true)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot" and !is_dead:
		shooting_timer.start()
	if anim_name == "death":
		queue_free()


func _on_shooting_timer_timeout():
	if !is_dead:
		var projectile = projectile_inst.instantiate()
		get_tree().get_root().get_child(-1).add_child(projectile)
		projectile.global_position = projectile_spawn_point.global_position
		var player_pos = player.global_position
		player_pos.y += .4
		var new_dir = player_pos - projectile_spawn_point.global_position 
		projectile.velocity = new_dir
		sounds["shoot"].play()
		animator.play("shoot")
