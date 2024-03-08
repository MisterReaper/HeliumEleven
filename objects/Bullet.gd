extends Node2D
@export var speed: int
@export var damage: int
@export var sourcePlayer: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

func _on_bullet_collision_area_entered(area):
	if area.name == "hitbox":
		print_debug(area.name + " entered")
		queue_free()
	else:
		pass
	
