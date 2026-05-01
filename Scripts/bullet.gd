extends Area2D

var velocity: Vector2 = Vector2()
var lifetime = 20 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	#connect("body_entered", self._on_body_entered)
	rotation = velocity.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.take_damage(1)
		queue_free()
