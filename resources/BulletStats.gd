extends Resource
class_name BulletStats

@export var bulletSizeMultiplikator: int
@export var bulletSpeed: int
@export var reloadTime: int
@export var bullet = "res://objects/Bullet.tscn"
enum pattern {STRAIGHT_SHOT, V_SHOT, SINUS_BLAST}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	pass
