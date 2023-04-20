extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance_to_surface = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$UILayer/HBoxContainer/FuelGauge.max_value = $Node2D/Lander.lander_fuel


func _process(delta):
	$Node2D/Lander/RayCast2D.global_rotation = 0
	
	dts_Indicator()
	h_Speed_indicator()
	v_Speed_indicator()

func dts_Indicator():
	
	print($Node2D/Lander/RayCast2D.get_collider())
	if $Node2D/Lander/RayCast2D.is_colliding():
		
		var collision_point = $Node2D/Lander/RayCast2D.get_collision_point()
		var lander_origin = $Node2D/Lander/RayCast2D.global_position
		distance_to_surface = snapped(lander_origin.distance_to(collision_point)/1000, 0.01)
		$Node2D/Lander/RayCast2D.add_exception($Node2D/Lander)
#	$Node2D/RayCast2D.add_exception($Node2D/Lander)
	
	
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.add_text(str(distance_to_surface)+" km")

func h_Speed_indicator():
	
	var h_speed = snapped($Node2D/Lander.get_linear_velocity().x * 3.6, 1)
	if h_speed < 0:
		h_speed = h_speed*-1
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.add_text(str(h_speed)+" km/h")

func v_Speed_indicator():
	var v_speed = snapped($Node2D/Lander.get_linear_velocity().y * 3.6, 1)
	if v_speed < 0:
		v_speed = v_speed*-1
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.add_text(str(v_speed)+" km/h")
	
func getDistance_to_Surface():
	return distance_to_surface
	
