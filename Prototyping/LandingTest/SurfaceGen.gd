extends Node2D

var noise
var on_screen = false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()


	
	var poly = Polygon2D.new()
	var i = DisplayServer.screen_get_size().x
	var polygon = PackedVector2Array([])
	var height = 1
	var width = 1
	
	polygon.append(Vector2(1,1000))
	for x in i:
		width += 1
		height += noise.get_noise_1d(x)
		polygon.append(Vector2(width,height))
		x +=1
	print(width," ",height)
	
	polygon.append(Vector2(width,1000))
	poly.set_polygon(polygon)
	$Surface.add_child(poly)
	var col_poly = CollisionPolygon2D.new()
	col_poly.set_polygon(polygon)
	$Surface.add_child(col_poly)

func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true
