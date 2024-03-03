extends TileMap

var room_count = 20      # Number of rooms to generate
var radius = 5
var roomSize = 5
var map_data = []  # Stores generated map information (e.g., room positions, shapes)
	
func _ready():
	generate_map()
	

func generate_map():
	for i in range(0, room_count):
		var randomPoint = getRandomPointInCircle(radius)
		generate_room(randomPoint[0], randomPoint[1])
	
func generate_room(x, y):
	var newRoom = Room.new(Vector2(x,y), self,  "template", 5)
	map_data.append(newRoom)

	
func getRandomPointInCircle(radius):
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	return [floor(r * cos(theta)), floor(r * sin(theta))]

func setThingy(x,y):
	set_cell(0, Vector2i(x,y), 0, Vector2i(3,7))
	
func deleteThingy(x,y):
	erase_cell(0, Vector2i(x,y))

func _draw():
	var canDraw = true
	for room in map_data:
		if(room.isOverlapping):
			canDraw = false
	print(canDraw)

	for room in map_data:
		for x in range(0, 5):
			for y in range(0, 5):
				setThingy(x+room.position.x+50, y+room.position.y+50)


