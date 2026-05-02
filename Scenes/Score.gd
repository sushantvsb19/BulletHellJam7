extends Label

var timer := 0.0
var paused := false
var cooldown := 0.

var last_score := 0

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
		paused = true
	else:
		paused = false

	if not paused:
		timer += delta

	if timer >= 1.0:
		timer -= 1.0
		Global.Score -= 1


	if Global.Score >= last_score + 5:
		cooldown = 3.0

	last_score = Global.Score
	self.text = str(Global.Score)
	
