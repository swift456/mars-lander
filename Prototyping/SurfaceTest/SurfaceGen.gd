extends Node2D

var noise
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise = FastNoiseLite.new()
	noise.noise_type = 5
	noise.fractal_octaves = 2
	noise.fractal_lacunarity = 6
	noise.fractal_type = 1
	noise.frequency = 0.01
	noise.seed = randi()

	
	
	var poly = Polygon2D.new()
	var y = get_viewport_rect().size.x
	var polygon = PackedVector2Array([])
	var height = 1
	var width = 1
	polygon.append(Vector2(1,1000))
	for x in y:
		width += 1
		height += noise.get_noise_1d(x)
		polygon.append(Vector2(width,height))
		x +=1
	print(width," ",height)
	polygon.append(Vector2(width,1000))
	poly.set_polygon(polygon)
	add_child(poly)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
