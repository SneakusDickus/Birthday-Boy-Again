extends Node3D

enum Types {
	AMMO,
	MED_KIT
}

@onready var item_node := $Item
@onready var item_type_inst: Dictionary[Types, PackedScene]= {
	Types.AMMO : preload("res://Enemies/ItemDrop/Scene/ammo.tscn"),
	Types.MED_KIT : preload("res://Enemies/ItemDrop/Scene/med_kit.tscn")
}

var item_type
var item_obj

func _ready() -> void:
	item_randomize()
	item_node.add_child(item_obj)


func item_randomize() -> void:
	if PlayerData.hp <= 7: item_type = Types.MED_KIT
	if PlayerData.current_ammo <= 5: item_type = Types.AMMO
	
	if item_type != null:
		item_obj = item_type_inst[item_type].instantiate()
