extends CharacterBody2D

var health = 2
var move_speed = 2

var _movement_vector: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_movement_vector = Vector2()
	
	if Input.is_action_pressed("MoveUp"):
		_movement_vector.y -= 1
	
	if Input.is_action_pressed("MoveDown"):
		_movement_vector.y += 1
	
	if Input.is_action_pressed("MoveLeft"):
		_movement_vector.x -= 1
	
	if Input.is_action_pressed("MoveRight"):
		_movement_vector.x += 1
	
	position += _movement_vector.normalized()*move_speed

func take_damage(amount: int):
	health-=amount
	if health<=0:
		queue_free()
