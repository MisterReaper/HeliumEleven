extends Resource
class_name BulletStats

@export var bulletSizeMultiplikator: float
@export var bulletSpeed: int
@export var reloadTime: float
@export var gunPorts: int
@export var bullet = preload("res://objects/Bullet.tscn")
@export var damage: int
@export var pattern: patterns
enum patterns {STRAIGHT_SHOT, V_SHOT, SINUS_BLAST, ROTATION, NONE}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(root_node, position, rotation_degrees, source = false):
	match pattern:
		patterns.STRAIGHT_SHOT:
			var bulletInstance = bullet.instantiate()
			bulletInstance.position = position
			bulletInstance.rotation_degrees = rotation_degrees
			bulletInstance.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance.speed = bulletSpeed
			bulletInstance.damage = damage
			bulletInstance.sourcePlayer = source
			root_node.add_child(bulletInstance)
			
		patterns.V_SHOT:
			var bulletInstance1 = bullet.instantiate()
			var bulletInstance2 = bullet.instantiate()
			bulletInstance1.position = position
			bulletInstance1.rotation_degrees = rotation_degrees+450
			bulletInstance1.speed = bulletSpeed
			bulletInstance1.damage = damage
			bulletInstance1.sourcePlayer = source
			bulletInstance1.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance1.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance2.position = position
			bulletInstance2.rotation_degrees = rotation_degrees-450
			bulletInstance2.speed = bulletSpeed
			bulletInstance2.damage = damage
			bulletInstance2.sourcePlayer = source
			bulletInstance2.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance2.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			root_node.add_child(bulletInstance1)
			root_node.add_child(bulletInstance2)
			
		patterns.ROTATION:
			if gunPorts != 0:
				var step = 360 / gunPorts
				for i in range(gunPorts):
					var bulletInstance = bullet.instantiate()
					bulletInstance.position = position
					bulletInstance.rotation_degrees = rotation_degrees+(step*i)
					bulletInstance.speed = bulletSpeed
					bulletInstance.damage = damage
					bulletInstance.sourcePlayer = source
					bulletInstance.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
					bulletInstance.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
					root_node.add_child(bulletInstance)
