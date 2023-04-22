extends Control

var collision_point = Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance_to_surface = 0
var scene_initialised = false
var recieved_thrust_value = 0
signal distance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


func get_surface_position(state):
		if $Lander/DtSLander.is_colliding():
			collision_point = $Lander/DtSLander.get_collision_point()
			print("Collided!")
			scene_initialised = true
		dts_Indicator()
		emit_signal("distance", collision_point)
		return 

func fuel_gauge(value):
	if $UILayer/HBoxContainer/FuelGauge.value > 0:
		$UILayer/HBoxContainer/FuelGauge.value -= value/80
		print("FuelGauge ", $UILayer/HBoxContainer/FuelGauge.value)
	else:
		$UILayer/HBoxContainer/FuelGauge.value = 0
		print("Out of fuel!")

func _process(delta):
	get_surface_position(scene_initialised)
	print(distance_to_surface)
	fuel_gauge(recieved_thrust_value)
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
	
func _on_v_slider_value_changed(value):
	recieved_thrust_value = value
