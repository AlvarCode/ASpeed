extends Area2D

var milsecs = 0
var direction = 1

func _ready():
	position.x = 200
	position.y = 200

func _physics_process(delta):
	milsecs += 1
	position.y += 20 * direction * delta
	if milsecs == 59:
		direction *= -1
		milsecs = 0
