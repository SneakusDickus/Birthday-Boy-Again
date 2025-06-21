extends CanvasLayer

@onready var main_camera := $".."
@onready var gun_camera := $"../SubViewportContainer/SubViewport/GunCamera"
@onready var ammo_label := $AmmoLabel
@onready var player := $"../../.."

func _ready():
	gun_camera.environment = main_camera.environment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/Aim.position = get_viewport().size / 2
	$"../SubViewportContainer/SubViewport".size = get_viewport().size
	gun_camera.global_transform = main_camera.global_transform
	
	ammo_label.text = "Ammo: " + str(player.current_ammo) + "/" + str(PlayerData.max_ammo)
