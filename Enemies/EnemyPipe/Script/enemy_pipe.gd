extends CharacterBody3D

@export var damage: int = 5

@onready var sounds: Dictionary[String, AudioStreamPlayer3D] = {
	"hurt" : $Sounds/HurtSound,
	"death" : $Sounds/DeathSound,
	"attack" : $Sounds/AttackSound,
	"spawn" : $Sounds/SpawnSound
}

@onready var animator := $AnimationPlayer
@onready var attack_hitbox := $Rig2/Skeleton3D/PipeBone/Pipe/AttackHitbox/CollisionShape3D

var player: CharacterBody3D
var rotation_z: float
var rotation_x: float
var move_to_player := true
var can_attack := false
var is_death := false


func _ready():
	sounds["spawn"].play()
	rotation_z = global_rotation.z
	rotation_x = global_rotation.x
	attack_hitbox.set_deferred("disabled", true)


func _physics_process(delta):
	# Add the gravity.
	if player != null and move_to_player:
		look_at(player.global_position, Vector3(0, 1, 0) ,true)
		global_rotation = Vector3(rotation_x, global_rotation.y, rotation_z)
		
		var dir_x = player.global_position.x - global_position.x
		var dir_z = player.global_position.z - global_position.z
		velocity.x = dir_x
		velocity.z = dir_z
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	update_animation()
	move_and_slide()


func update_animation() -> void:
	if !is_death:
		if velocity.x != 0 or velocity.z != 0:
			animator.play("run")
		elif !can_attack and !animator.is_playing():
			animator.play("idle")


func _on_player_checker_body_entered(body):
	if body.name == "Player":
		player = body


func _on_attack_checker_body_entered(body):
	if body.name == "Player":
		move_to_player = false
		can_attack = true
		animator.play("attack")
		velocity = Vector3.ZERO
		attack_hitbox.set_deferred("disabled", false)


func _on_attack_checker_body_exited(body):
	if body.name == "Player":
		can_attack = false
		attack_hitbox.set_deferred("disabled", true)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		if can_attack:
			animator.play("attack")
		else:
			move_to_player = true
			animator.play("idle")
		attack_hitbox.set_deferred("disabled", false)
	if anim_name == "death":
		queue_free()


func _on_enemy_hp_death() -> void:
	sounds["death"].play()
	$AttackChecker/CollisionShape3D.set_deferred("disabled", true)
	$PlayerChecker/CollisionShape3D.set_deferred("disabled", true)
	$Rig2/Skeleton3D/TorsoHitBox/Node3D/EnemyTorso/CollisionShape3D.set_deferred("disabled", true)
	$Rig2/Skeleton3D/HeadHitBox/Node3D/EnemyHead/CollisionShape3D.set_deferred("disabled", true)
	$CollisionShape3D.set_deferred("disabled", true)
	attack_hitbox.set_deferred("disabled", true)
	move_to_player = false
	velocity = Vector3.ZERO
	is_death = true
	animator.play("death")


func _on_enemy_hp_damage():
	sounds["hurt"].play()
	player = PlayerData.player


func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		sounds["attack"].play()
		attack_hitbox.set_deferred("disabled", true)
		body.emit_signal("get_damage", damage)
