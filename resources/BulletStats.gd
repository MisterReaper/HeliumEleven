extends Resource
class_name BulletStats

@export var bulletSizeMultiplikator: float
@export var bulletSpeed: int
@export var reloadTime: float
@export var gunPorts: int
@export var bullet = preload("res://objects/Bullet.tscn")
@export var pattern: patterns
enum patterns {STRAIGHT_SHOT, V_SHOT, SINUS_BLAST, ROTATION, NONE}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(root_node, position, rotation_degrees):
	match pattern:
		patterns.STRAIGHT_SHOT:
			print_debug("PEW "+ str(position)+" "+ str(rotation_degrees))
			var bulletInstance = bullet.instantiate()
			bulletInstance.position = position
			bulletInstance.rotation_degrees = rotation_degrees
			bulletInstance.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance.apply_impulse(Vector2(bulletSpeed,0).rotated(deg_to_rad(rotation_degrees)), Vector2(0,0))
			root_node.add_child(bulletInstance)
			
		patterns.V_SHOT:
			print_debug("V-SHOT, V-SHOT, "+str(rotation_degrees))
			var bulletInstance1 = bullet.instantiate()
			var bulletInstance2 = bullet.instantiate()
			bulletInstance1.position = position
			bulletInstance1.rotation_degrees = rotation_degrees+450
			bulletInstance1.apply_impulse(Vector2(bulletSpeed, 0).rotated(deg_to_rad(rotation_degrees+30)), Vector2(0,0))
			bulletInstance1.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance1.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance2.position = position
			bulletInstance2.rotation_degrees = rotation_degrees-450
			bulletInstance2.apply_impulse(Vector2(bulletSpeed, 0).rotated(deg_to_rad(rotation_degrees-30)), Vector2(0,0))
			bulletInstance2.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			bulletInstance2.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
			root_node.add_child(bulletInstance1)
			root_node.add_child(bulletInstance2)
			
		patterns.ROTATION:
			print_debug("ROTATION, A FLOWER ON THE BATTLE FIELD!")
			var step = 360 / gunPorts
			for i in range(gunPorts):
				var bulletInstance = bullet.instantiate()
				bulletInstance.position = position
				bulletInstance.rotation_degrees = rotation_degrees+(step*i)
				bulletInstance.apply_impulse(Vector2(bulletSpeed, 0).rotated(deg_to_rad(rotation_degrees+(step*i))), Vector2(0,0))
				bulletInstance.get_node("BulletCollision").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
				bulletInstance.get_node("BulletSprite").scale = Vector2(bulletSizeMultiplikator,bulletSizeMultiplikator)
				root_node.add_child(bulletInstance)
				print_debug("Fired Gunport "+ str(i)+ " at RD: "+ str(deg_to_rad(bulletInstance.rotation_degrees)))
