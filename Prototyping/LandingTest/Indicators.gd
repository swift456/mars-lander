extends Control

var collision_point
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance_to_surface = 0
var scene_initialised = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$UILayer/HBoxContainer/FuelGauge.max_value = $Lander.lander_fuel
	


func get_surface_position(state):
	if !state:
		if $Lander/DtSLander.is_colliding():
			$Lander/DtSLander.add_exception($Lander)
			collision_point = $Lander/DtSLander.get_collision_point()
			print(collision_point)
			scene_initialised = true
	else:
		dts_Indicator()
		return 



func _process(delta):
	get_surface_position(scene_initialised)
	
	
	h_Speed_indicator()
	v_Speed_indicator()

func dts_Indicator():
	
#	print($Node2D/Lander/DtSLander.get_collider())
		
	
	var lander_origin = $Lander.get_global_position()
	distance_to_surface = snapped(lander_origin.distance_to(collision_point)/1000, 0.01)
	$Lander/DtSLander.add_exception($Lander)
#	$Node2D/RayCast2D.add_exception($Node2D/Lander)
	
	
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer4/DtSIndicator.add_text(str(distance_to_surface)+" km")

func h_Speed_indicator():
	
	var h_speed = snapped($Lander.get_linear_velocity().x * 3.6, 1)
	if h_speed < 0:
		h_speed = h_speed*-1
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer3/HSpeedIndicator.add_text(str(h_speed)+" km/h")

func v_Speed_indicator():
	var v_speed = snapped($Lander.get_linear_velocity().y * 3.6, 1)
	if v_speed < 0:
		v_speed = v_speed*-1
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.clear()
	$UILayer/HBoxContainer/MarginContainer4/HBoxContainer/VBoxContainer/MarginContainer2/VSpeedIndicator.add_text(str(v_speed)+" km/h")
	
func getDistance_to_Surface():
	return distance_to_surface
	
