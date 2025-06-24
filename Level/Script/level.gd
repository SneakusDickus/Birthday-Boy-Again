extends Node3D

@export var total_room_number: int

@onready var room_inst := preload("res://Level/Models/room.tscn")

@onready var center_room := $Rooms/CenterRoom
@onready var room_node := $Rooms

var exist_rooms: Array[Node3D]

var room_counter = 1

func _ready():
	var areas = center_room.areas
	for key in areas:
		await get_tree().create_timer(0.15).timeout
		var room = room_inst.instantiate()
		room_node.add_child(room)
		room.global_position = areas[key].global_position 
		room_counter += 1
		exist_rooms.append(room) 
		room.name = str(randi_range(1, 1000))
	await get_tree().create_timer(0.15).timeout
	_generate_level(total_room_number)


func _generate_level(max_number_rooms: int) -> void:
	if room_counter == max_number_rooms: return
	
	var room: Node3D = exist_rooms.pick_random()
	var areas = room.areas
	var adj_rooms = room.adjoining_rooms
	
	for key in adj_rooms:
		if adj_rooms[key] != null:
			continue
		var new_room = room_inst.instantiate()
		room_node.add_child(new_room)
		new_room.global_position = areas[key].global_position
		new_room.name = "child_" + str(randi_range(1, 1000))
		
		await get_tree().create_timer(0.15).timeout
		
		exist_rooms.append(new_room)
		adj_rooms[key] = new_room
		room_counter += 1
		
		break
	_generate_level(total_room_number)
	

func _input(event):
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_right"):
		_generate_level(total_room_number)
