extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance_to_surface = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Node2D/Lander/RayCast2D.global_rotation = 0
	dts_Indicator()
	h_Speed_indicator()
	v_Speed_indicator()

func dts_Indicator():
	
	get_parent().rotation
	
	if $Node2D/Lander/RayCast2D.is_colliding():
		
		var collision_point = $Node2D/Lander/RayCast2D.get_collision_point()
		var lander_origin = $Node2D/Lander/RayCast2D.global_position
		distance_to_surface = round(lander_origin.distance_to(collision_point))
#	$Node2D/RayCast2D.add_exception($Node2D/Lander)
	
	
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.add_text(str(distance_to_surface))

func h_Speed_indicator():
	
	var h_speed = round($Node2D/Lander.get_linear_velocity().x)
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.add_text(str(h_speed))

func v_Speed_indicator():
	var v_speed = round($Node2D/Lander.get_linear_velocity().y)
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.add_text(str(v_speed))
	
func getDistance_to_Surface():
	return distance_to_surface
	
