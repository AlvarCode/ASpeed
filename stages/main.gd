extends Node

@export var intents: int = 1
var car_scene: PackedScene = preload("res://scenes/car_mob.tscn")
var gas_scene: PackedScene = preload("res://scenes/gass.tscn")
var score: int
var countdown: int
var hits: int
var speed: float
var gass_level: float
var gas_decrement: float

# ====> METHODS <====

func _ready():
	get_tree().call_group("game_controls", "hide")
	set_physics_process(false)

func _physics_process(delta):
	# print(gas_decrement)
	$HUD/GasLevel.value -= 10 * delta
	if $HUD/GasLevel.value <= 50:
		generate_gas()
	if $HUD/GasLevel.value == 0:
		game_over("¡Te quedaste sin combustible!")	

func start_game():
	score = 0
	hits = 0
	countdown = 3
	speed = 60
	gas_decrement = 1

	get_tree().call_group("sprites", "queue_free")
	get_tree().call_group("lobby_controls", "hide")
	get_tree().call_group("game_controls", "show")

	$Player.position = $StartPosition.position
	$HUD/Timer.show()
	$HUD/Timer.text = str(countdown)
	$StartTimer.start()
	$HUD/GasLevel.value = 100
	$HUD/Score.text = "SCORE: 0"
	$HUD/Speed.text = str(speed) + " Km/h"

func game_over(message: String):
	set_physics_process(false)
	get_tree().call_group("timers", "stop")
	get_tree().call_group("game_controls", "hide")
	get_tree().call_group("lobby_controls", "show")
	$HUD/Title.text = "Game Over"	
	$HUD/Message.text = message
	$HUD/Timer.hide()
	$HUD/StartBtn.hide()
	await get_tree().create_timer(2).timeout
	$HUD/StartBtn.show()

func create_enemy():
	var enemy = car_scene.instantiate()
	enemy.position.x = randf_range(0, get_viewport().size.x)
	enemy.linear_velocity.y = speed * 3
	enemy.add_to_group("sprites")
	add_child(enemy)

func generate_gas():
	# calcular posicicón aleatoria
	var gas = gas_scene.instantiate()
	gas.position.x = randf_range(0, get_viewport().size.x)
	add_child(gas)

# ====> EVENT HANDLERS <====

func _on_enemy_timer_timeout():
	create_enemy()

func _on_score_timer_timeout():
	score += 1
	$HUD/Score.text = "SCORE: " + str(score)

func _on_dificulty_timer_timeout():
	speed += 10
	gas_decrement += gas_decrement
	$HUD/Speed.text = str(speed) + " Km/h"

func _on_start_btn_pressed():
	print("Juego iniciado")
	start_game()

func _on_start_timer_timeout():
	countdown -= 1
	$HUD/Timer.text = str(countdown)
	if countdown == 0:
		$HUD/Timer.visible = false
		$StartTimer.stop()
		get_tree().call_group("timers", "start")
		create_enemy()
		set_physics_process(true)

func _on_player_beaten(body):
	hits += 1
	if hits == intents:
		game_over("¡Chocaste!")
