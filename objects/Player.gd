extends CharacterBody2D

class_name  Player

@export var playerStat:StatBlock
@export var bulletStats:BulletStats
@onready var interactionBox = $interactionBox
@onready var timer = $ReloadTimer
var direction

func _physics_process(delta):
	handleInput()
	move_and_slide()
	
func handleInput():
	if Input.is_key_pressed(KEY_F):
		contextAction()
	
	if Input.is_key_pressed(KEY_SPACE):
		if timer.time_left == 0:
			fire()
			timer.wait_time = bulletStats.reloadTime
			timer.start()
		
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	velocity = moveDirection * playerStat.movespeed
	if moveDirection.length():
		if moveDirection.y:
			changeDirection("down" if moveDirection.y > 0.0 else "up")
		else:
			changeDirection("left" if moveDirection.x < 0.0 else "right")
	look_at(get_global_mouse_position())

func changeDirection(newDirection):
	if direction != newDirection:
		direction = newDirection

func contextAction():
	if(interactionBox.get_overlapping_areas() == null): return
	for area in interactionBox.get_overlapping_areas():
		print_debug(area.get_parent().name)
		if area.get_parent() is Interactable:
			print_debug("Area belongs to a interactable object")
			area.get_parent().interact()

func fire():
	bulletStats.shoot(get_tree().get_root(), get_global_position(), rotation_degrees, true)


func _on_hitbox_area_entered(area):
	#playerStat.health = playerStat.health - area.get_parent().damage
	print_debug(area.name)
	if(area.name == "BulletCollision" and !area.get_parent().sourcePlayer):
		playerStat.health -= area.get_parent().damage
		area.get_parent().queue_free()
		print_debug(str(playerStat.health))
		if(playerStat.health <= 0):
			self.queue_free()
