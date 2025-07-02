extends Node3D

@export var enemy_hp_node: Node3D

@onready var item_node := $Item
@onready var item_type_inst: Dictionary[String, PackedScene]= {
	"ammo" : preload("res://Enemies/ItemDrop/Scene/ammo.tscn"),
	"med_kit" : preload("res://Enemies/ItemDrop/Scene/med_kit.tscn")
}

var item_type = "null"
var item_obj


func _ready() -> void:
	enemy_hp_node.connect("death", _on_enemy_death)


func item_randomize() -> void:
	if PlayerData.hp <= 7: item_type = "med_kit"
	if PlayerData.current_ammo <= 5: item_type = "ammo"
	
	if item_type == "null":
		var chance = randi_range(1, 101)
		if chance in range(1, 35):
			item_type = "ammo"
		elif chance in range(36, 50):
			item_type = "med_kit"


func _on_pickup_zone_body_entered(body):
	if item_type == "null": queue_free()
	if body.name == "Player":
		match item_type:
			"ammo":
				body.get_ammo()
			"med_kit":
				body.get_hp()
		queue_free()


func _on_enemy_death():
	item_randomize()
	if item_type != "null":
		item_obj = item_type_inst[item_type].instantiate()
		item_node.add_child(item_obj)
		item_node.global_position = enemy_hp_node.global_position
	var main_node = get_tree().root.get_child(-1)
	reparent(main_node)
