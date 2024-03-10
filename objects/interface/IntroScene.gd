extends Control

@export var image_transition_time: float = 0.5
@export var image_invisible_time: float = 1.5
@export var label_reset_time: float = 0.5

#Intro font m3x6 by daniel linssen
var storylines: Array[String]= [
	"21XX CE: Earth is overpopulated and environmental\ndegradation reduces the arable land even further.",
	"Faced with this catastrophe Humanity has made the\nbrave decision to leave its cradle.\nSeeking a better future among the stars.",
	"Sending many ships ahead to establish way points\nfor its journey and mine the needed Ressources.",
	"Among these many ships is the Helium Eleven.\nA research and personal carrier on its way to join\nthe helium rich Jules colony on Jan-553n.",
	"But the ship has been struck by an unknown object\nunable to land and stuck in orbit.",
	"The 54-'Defensiv Internal Ship Towers'-System,\ndesigned to protect the colonists, has went\nseems to be malfunctioning.",
	"The ships AI 8-Key has locked the escape pods\nand blocked any communication to and from\nJules or Earth.",
	"8-Key has now begun to unfreeze the personal\npromising them freedom should they reach them.",
	"Crawling out of your Cryo Chamber will you claw\nyour way to the escape pod or die trying?"
]

@onready var image: TextureRect = $HBoxContainer/VBoxContainer/NarrationPicture
@onready var text: Label = $HBoxContainer/VBoxContainer/Narration
@onready var background_music: AudioStreamPlayer = $BackgroundMusic

func _ready() -> void:
	var font_width: int
	background_music.play()
	
	for storyline_index in range(len(storylines)):
		var intro_name: String = "intro_" + str(storyline_index + 1)
		
		image.texture = load("res://assets/intro/intro_slide_{imageIndex}.png".format({"imageIndex": storyline_index + 1}))
		text.text = storylines[storyline_index]
		await get_tree().create_timer(4).timeout
		print_debug(str(storyline_index) + " " + "intro_slide_{imageIndex}.png".format({"imageIndex": storyline_index + 1}))
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
	
func _process(_delta):
	pass


func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
