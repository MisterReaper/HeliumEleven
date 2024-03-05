extends Node2D
@export var playerStat:StatBlock
@export var bulletStats:BulletStats

@onready var shootTimer = $ShootTimer 

# Called when the node enters the scene tree for the first time.
func _ready():
	shootTimer.wait_time = bulletStats.reloadTime
	shootTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shoot_timer_timeout():
	print_debug("Enemy Fire!")
	bulletStats.shoot(get_tree().get_root(), get_global_position(), rotation_degrees)
