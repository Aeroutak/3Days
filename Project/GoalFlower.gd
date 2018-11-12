#Level Complete Flower
extends Area2D

export(String, FILE, ".tscn") var lvl_scene

func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "player":
			get_tree().change_scene(lvl_scene)
	
	pass

