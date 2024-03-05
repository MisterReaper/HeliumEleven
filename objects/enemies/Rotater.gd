extends "res://objects/enemies/Enemy.gd"
var rotateSpeed = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	shootTimer.wait_time = bulletStats.reloadTime
	shootTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(rotateSpeed*delta)

func _on_shoot_timer_timeout():
	bulletStats.shoot(get_tree().get_root(), get_global_position(), rotation_degrees)
