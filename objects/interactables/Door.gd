extends "res://objects/interactables/Interactable.gd"
@onready var open = false
#default is down, direction is import for with animation frame we show for the door
@onready var direction = "down"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func openDoor():
	# Placeholder Open Doors of Room when enemies are defeated.
	# Pretty much just a swap of Animation frame
	open = true

func interact():
	# Port Player to connected Room
	if open:
		#Port Player
		pass
