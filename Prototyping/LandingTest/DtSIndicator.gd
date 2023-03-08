extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dts_Indicator()
	h_Speed_indicator()
	v_Speed_indicator()

func dts_Indicator():
	var distance_to_surface = round($Node2D/Lander.get_global_position().distance_to($Surface.get_global_position()))
	
	$DtSIndicator.clear()
	$DtSIndicator.add_text(str(distance_to_surface))

func h_Speed_indicator():
	var h_speed = round($Node2D/Lander.get_linear_velocity().x)
	$HSpeedIndicator.clear()
	$HSpeedIndicator.add_text(str(h_speed))

func v_Speed_indicator():
	var v_speed = round($Node2D/Lander.get_linear_velocity().y)
	$VSpeedIndicator.clear()
	$VSpeedIndicator.add_text(str(v_speed))
	
	
