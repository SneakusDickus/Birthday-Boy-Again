extends Node3D

@export var total_room_number: int

#@onready var room_inst := preload("res://Rooms/Scenes/room8_floor1.tscn")

@onready var array_room_inst: Array[PackedScene] = [
	preload("res://Rooms/Scenes/room1_floor1.tscn"),
	preload("res://Rooms/Scenes/room2_floor1.tscn"),
	preload("res://Rooms/Scenes/room3_floor1.tscn"),
	preload("res://Rooms/Scenes/room4_floor1.tscn"),
	preload("res://Rooms/Scenes/room5_floor1.tscn"),
	preload("res://Rooms/Scenes/room6_floor1.tscn"),
	preload("res://Rooms/Scenes/room7_floor1.tscn"),
	preload("res://Rooms/Scenes/room8_floor1.tscn"),
]

@onready var center_room := $Rooms/StartroomFloor1
@onready var room_node := $Rooms

var exist_rooms: Array[Node3D]

var current_room = 0
var room_counter = 1

func _ready():
	var areas = center_room.areas
	for key in areas:
		await get_tree().create_timer(0.075).timeout
		var room_inst = array_room_inst[current_room]
		var room = room_inst.instantiate()
		room_node.add_child(room)
		room.global_position = areas[key].global_position 
		room_counter += 1
		exist_rooms.append(room)
		current_room += 1
		#room.name = str(randi_range(1, 1000))
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
		var room_inst = array_room_inst[current_room]
		var new_room = room_inst.instantiate()
		room_node.add_child(new_room)
		new_room.global_position = areas[key].global_position
		#new_room.name = "child_" + str(randi_range(1, 1000))
		
		await get_tree().create_timer(0.15).timeout
		
		exist_rooms.append(new_room)
		current_room += 1
		adj_rooms[key] = new_room
		room_counter += 1
		
		break
	_generate_level(total_room_number)
