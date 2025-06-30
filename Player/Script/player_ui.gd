extends CanvasLayer

@export var player: CharacterBody3D

@onready var main_camera := $".."
@onready var gun_camera := $"../SubViewportContainer/SubViewport/GunCamera"
@onready var ammo_label := $AmmoLabel
@onready var vignette := $Control/Vignette
@onready var animator := $AnimationPlayer

var max_player_hp: int

func _ready():
	gun_camera.environment = main_camera.environment
	max_player_hp = PlayerData.hp
	vignette.material["shader_parameter/vignette_intensity"] = 0
	player.connect("get_damage", _on_player_get_damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/Aim.position = get_viewport().size / 2
	$"../SubViewportContainer/SubViewport".size = get_viewport().size
	gun_camera.global_transform = main_camera.global_transform
	
	ammo_label.text = "Ammo: " + str(player.current_ammo) + "/" + str(PlayerData.max_ammo)
	
	# vingette animation


func _on_player_get_damage(damage: int) -> void:
	var player_hp_percent = (max_player_hp - PlayerData.hp) * 100 / max_player_hp
	var current_vignette = 2.5 * player_hp_percent / 100
	vignette.material["shader_parameter/vignette_intensity"] = current_vignette
	if PlayerData.hp <= 0:
		animator.play("death_screen")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death_screen":
		PlayerData.hp = max_player_hp
		get_tree().reload_current_scene()
