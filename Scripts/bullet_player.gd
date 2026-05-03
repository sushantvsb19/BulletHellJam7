extends Area2D

var speed = 500 





func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta






func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
