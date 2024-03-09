extends Control

@onready var pauseDelay = $PauseDelay

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true # Replace with function body.
	pauseDelay.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_P) && pauseDelay.is_stopped():
		get_tree().paused = false
		self.queue_free()


func _on_unpause_button_pressed():
	get_tree().paused = false
	self.queue_free()
