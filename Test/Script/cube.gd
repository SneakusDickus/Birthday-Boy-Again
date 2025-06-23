extends MeshInstance3D


func take_shoot():
	var new_material = StandardMaterial3D.new()
	new_material.albedo_color = Color(randf(), randf(), randf(), 1)
	self.material_override = new_material
