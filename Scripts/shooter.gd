extends CharacterBody2D

enum ShooterType { Paranoia, ADHD }
enum AimType { Direct, Predictive, Random }

@export var type = ShooterType.Paranoia

const obj_bullet = preload("res://Objects/Bullet.tscn")
var fire_delay: float
var aim_type: AimType
var shot_speed: int
var num_spread_shots: int

var _time_since_shot = 0
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
			
		ShooterType.ADHD:
			fire_delay = 1
			aim_type = AimType.Random
			shot_speed = 150
			num_spread_shots = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_since_shot+=delta
	
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
				var prediction = target.position+(target._movement_vector*60*target_dist/shot_speed)
				shot_angle = rad_to_deg((prediction-position).angle())
				
			AimType.Random:
				shot_angle = randf()*360
		
		for i in range(num_spread_shots):
			shoot(shot_angle+i*(360/num_spread_shots), shot_speed)

func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instantiate()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg_to_rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
