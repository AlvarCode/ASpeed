extends Area2D

@export var speed: int = 300
var gass_level: int = 100
signal beaten(body: Node2D)

func _physics_process(delta):
	var dir = 0
	if Input.is_action_pressed("move_right"):
		dir = 1
	elif Input.is_action_pressed("move_left"):
		dir = -1
	rotation = deg_to_rad(20 * dir)
	position.x += speed * dir * delta

func _on_body_entered(body: Node2D):
	if body.is_class("RigidBody2D"):
		beaten.emit(body)
		