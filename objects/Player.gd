extends CharacterBody2D

class_name  Player

@export var playerStat:StatBlock
@export var bulletStats:BulletStats
@onready var interactionBox = $interactionBox
var direction

func _physics_process(delta):
	handleInput()
	move_and_slide()
	
func handleInput():
	if Input.is_key_pressed(KEY_F):
		contextAction()
	
	if Input.is_key_pressed(KEY_SPACE):
		bulletStats.shoot()
		
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	velocity = moveDirection * playerStat.movespeed
	if moveDirection.length():
		if moveDirection.y:
			changeDirection("down" if moveDirection.y > 0.0 else "up")
		else:
			changeDirection("left" if moveDirection.x < 0.0 else "right")

func changeDirection(newDirection):
	if direction != newDirection:
		direction = newDirection

func contextAction():
	if(interactionBox.get_overlapping_areas() == null): return
	for area in interactionBox.get_overlapping_areas():
		print_debug(area.name)
		if area == load("res://objects/Interactable.gd"):
			print_debug("Area belongs to a interactable object")
