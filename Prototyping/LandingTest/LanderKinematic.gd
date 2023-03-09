extends CharacterBody2D


var velocity = Vector2.ZERO
var gravity = 3.7
var entry = Vector2(100,50)



func _physics_process(delta):
	if entry.y >= 0 && entry.x >= 0:
		entry -= Vector2(100,50)
	velocity.y += gravity * delta
	velocity.y += entry.y
	velocity.x += entry.x
	
	set_velocity(velocity)
	set_up_direction(Vector2(0, 0))
	move_and_slide()
	velocity = velocity
	
	
	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
