extends Node2D

const parachute = preload("res://Parachute.tscn")



# Called when the node enters the scene tree for the first time.


func _process(delta):
	if Input.is_action_just_pressed("parachute"):
		var instance = parachute.instance()
		add_child(instance)
		instance.position = Vector2($Lander/ParachuteSpawn.position.x,$Lander/ParachuteSpawn.position.y)
		
		
		var pinjoint = PinJoint2D.new()
		pinjoint.set("node_b", $Lander.get_path())
		pinjoint.set("node_a", instance.get_path())
		
		
		add_child(pinjoint)
		pinjoint.global_transform.origin = (instance.global_transform.origin - $Lander.global_transform.origin / 2)
		
		
		
		
