extends TileMap

var room_count = 50      # Number of rooms to generate
var radius = 20
var roomSize = 6
var bossRoomSize = 8
var numBossRooms = 5
var map_data = []  # Stores generated map information (e.g., room positions, shapes)
var accumulated_force = Vector2.ZERO
var old_data = []

	
func _ready():
	generate_map()

func generate_map():
	for i in range(0, numBossRooms):
		var randomPoint = getRandomPointInCircle(radius)
		generate_room(randomPoint[0], randomPoint[1], bossRoomSize)
	for i in range(0, room_count):
		var randomPoint = getRandomPointInCircle(radius)
		generate_room(randomPoint[0], randomPoint[1], roomSize)
	
func generate_room(x, y, size):
	var newRoom = Room.new(Vector2(x,y), self,  "template", size)
	map_data.append(newRoom)

	
func getRandomPointInCircle(radius):
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	return [floor(r * cos(theta)), floor(r * sin(theta))]

func setThingy(x,y):
	set_cell(0, Vector2i(x,y), 0, Vector2i(2,1))
	
func deleteThingy(x,y):
	erase_cell(0, Vector2i(x,y))

func _draw():
	var canDraw = true
	for room in map_data:
		if(room.isOverlapping()):
			canDraw = false
	for data in old_data:
		deleteThingy(data.x, data.y)
	old_data.clear()
	for room in map_data:
		for x in range(0, room.roomSize):
			for y in range(0, room.roomSize):
				old_data.append(Vector2(50+x+room.position.x-(room.roomSize/2), 50+y+room.position.y-(room.roomSize/2)))
				setThingy(50+x+room.position.x-(room.roomSize/2), 50+y+room.position.y-(room.roomSize/2))

func _process(delta):
	for room in map_data:
		accumulated_force = Vector2.ZERO
		var num_rooms = 0
		if room.has_overlapping_areas():
			for overlapping_area in room.get_overlapping_areas():
				if overlapping_area is Room:
					num_rooms += 1
					var distance = overlapping_area.position - room.position
					var desired_separation = 12   # Adjust this value based on your desired spacing
					if distance.length() < desired_separation:
						var force = distance.normalized() * (distance.length() - desired_separation)
						accumulated_force += force
			if num_rooms > 0:
				accumulated_force /= num_rooms
			room.position += accumulated_force * delta
