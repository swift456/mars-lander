extends RigidBody2D

var speed = 100
export var gravity = 8
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _physics_process(delta):
	velocity.y += gravity
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

	
	
	


func _on_Timer_timeout():
	pass
