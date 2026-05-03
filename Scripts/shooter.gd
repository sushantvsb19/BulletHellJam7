extends CharacterBody2D

enum ShooterType { Paranoia, ADHD }
enum AimType { Direct, Predictive, Random }
enum MovementType { None, Random }

@export var type = ShooterType.Paranoia

const obj_bullet = preload("res://Objects/Bullet.tscn")
var fire_delay: float
var aim_type: AimType
var shot_speed: int
var num_spread_shots: int
var movement_type: MovementType
var move_speed: int = 100
var min_wait: float = 0.5
var max_wait: float = 3

var _time_since_shot = 0
var _time_since_state = 0
var _wait_time = 0
var _players

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_players = get_tree().get_nodes_in_group("players")
	
	# Set up by type
	match type:
		
		ShooterType.Paranoia:
			fire_delay = 0.5
			aim_type = AimType.Direct
			shot_speed = 50
			num_spread_shots = 1
			movement_type = MovementType.None
			
		ShooterType.ADHD:
			fire_delay = 1
			aim_type = AimType.Random
			shot_speed = 150
			num_spread_shots = 3
			movement_type = MovementType.Random

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_since_shot+=delta
	_process_fire()
	
	_time_since_state+=delta
	_process_movement()

func _process_fire():
	if _time_since_shot >= fire_delay:
		_time_since_shot -= fire_delay
		
		var target_dist = -1.0
		var target
		var shot_angle
		
		for p in _players:
			if not p:
				break
			
			var dist_to_p = position.distance_to(p.position)
			if dist_to_p > target_dist:
				target_dist = dist_to_p
				target = p
		
		if not target:
			return
		
		match aim_type:
			
			AimType.Direct:
				shot_angle = rad_to_deg((target.position-position).angle())
			
			AimType.Predictive:
				var prediction = target.position+(target.velocity*target_dist/shot_speed)
				shot_angle = rad_to_deg((prediction-position).angle())
				
			AimType.Random:
				shot_angle = randf()*360
		
		for i in range(num_spread_shots):
			shoot(shot_angle+i*(360/num_spread_shots), shot_speed)

func _process_movement():
	var collided = move_and_slide()
		
	
	if (_time_since_state < _wait_time) and not collided:
		return
	
	_time_since_state = 0
	_wait_time = randf_range(min_wait, max_wait)
	
	match movement_type:
		
		MovementType.Random:
			var move_dir = Vector2.from_angle(deg_to_rad(randf()*360))
			velocity = move_dir*move_speed

func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instantiate()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg_to_rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
