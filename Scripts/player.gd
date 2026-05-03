class_name Player
extends CharacterBody2D

@onready var health_bar = $HealthBar
var health = 10
var move_speed = 100
var bullet_scene = preload("res://Objects/bullet_player.tscn")

var _movement_input: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health

func _physics_process(delta: float) -> void:
	_movement_input = Vector2()
	
	if Input.is_action_pressed("MoveUp"):
		_movement_input.y -= 1
	
	if Input.is_action_pressed("MoveDown"):
		_movement_input.y += 1
	
	if Input.is_action_pressed("MoveLeft"):
		_movement_input.x -= 1
	
	if Input.is_action_pressed("MoveRight"):
		_movement_input.x += 1
	
	if Input.is_action_just_pressed("Shoot"):
		var bullet_instance = bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = self.global_position
		bullet_instance.look_at(get_global_mouse_position())
		
	
	velocity = _movement_input.normalized()*move_speed
	move_and_slide()



func take_damage(amount: int):
	health-=amount
	Global.Score += 5
	if health<=0:
		queue_free()
