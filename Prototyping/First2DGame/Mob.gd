extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite").playing = true
	var mob_types = get_node("AnimatedSprite").frames.get_animation_names()
	get_node("AnimatedSprite").animation = mob_types[randi()%mob_types.size()]
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
