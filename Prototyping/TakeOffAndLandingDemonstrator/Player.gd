extends Area2D
signal hit

@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x += 1
	velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	print(position)
func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	get_node("CollisionShape2D").set_deferred("disabled", true)


