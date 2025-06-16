extends Node3D

@onready var room = preload("res://Level/Models/room.tscn")

@export var cells: Array[Marker3D] 

func _ready():
	for cell in cells:
		pass
