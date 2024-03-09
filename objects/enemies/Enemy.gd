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
	if playerStat.health <= 0:
		self.queue_free()
	print_debug("Enemy Fire!")
	bulletStats.shoot(get_tree().get_root().get_child(0), get_global_position(), rotation_degrees)


func _on_hitbox_area_entered(area):
	print_debug(area.name)
	if(area.name == "BulletCollision" and area.get_parent().sourcePlayer):
		playerStat.health -= area.get_parent().damage
		area.get_parent().queue_free()
		print_debug(str(playerStat.health))
		if(playerStat.health <= 0):
			self.queue_free()
