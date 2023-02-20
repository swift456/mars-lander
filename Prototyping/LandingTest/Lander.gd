extends RigidBody2D

const parachute = preload("res://Parachute.tscn")
var parachute_deployed = false
var drag = 0.1
var instancing = true
var instance = parachute
#
#
#
## Called when the node enters the scene tree for the first time.
#
#
func _process(delta):
	
	var debug_velocity = get_linear_velocity()
	if Input.is_action_just_released("parachute") || parachute_deployed:
		parachute_deployed = true
		print((debug_velocity),(drag),(parachute_deployed))
		if instancing:
			instance = parachute.instance()
			add_child(instance)
			instance.position = Vector2($ParachuteSpawn.position.x,$ParachuteSpawn.position.y + -10)
			var pinjoint = PinJoint2D.new()
			pinjoint.set("node_b", self.get_path())
			pinjoint.set("node_a", instance.get_path())
			add_child(pinjoint)
			pinjoint.global_transform.origin = (instance.global_transform.origin - self.global_transform.origin / 2)
			instancing = false
	if parachute_deployed && drag <= 2:
		print("Parachute Deployed!")
		instance.set_mass(drag)
		drag += 0.8 * delta
		if drag >= 5:
			parachute_deployed = false
			
	
	
	
	
#
#		
