extends Sprite2D

const obj_bullet = preload("res://Objects/Bullet.tscn")
var time_since_shot = 0
var fire_delay = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_shot+=delta
	if time_since_shot >= fire_delay:
		time_since_shot -= fire_delay
		shoot(randf()*360, 100)

func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instantiate()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg_to_rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
