extends TileMap

var room_count = 40      # Number of rooms to generate
var radius = 50
var roomSize = 10  # 22 x 14
var widthRoom = 22
var heightRoom = 14
var bossRoomSize = 15
var numBossRooms = 5
var desired_separation = 26
var map_data = []  # Stores generated map information (e.g., room positions, shapes)
var accumulated_force = Vector2.ZERO
var old_data = []
var roomsGenerated = 0
var processRan = false

	
func _ready():
	generate_map()

func generate_map():
#	for i in range(0, numBossRooms):
#		var randomPoint = getRandomPointInCircle(radius)
#		generate_room(randomPoint[0], randomPoint[1], bossRoomSize, 10)
	for i in range(0, room_count):
		var randomPoint = getRandomPointInCircle(radius)
		generate_room(randomPoint[0], randomPoint[1], widthRoom, heightRoom)
		roomsGenerated += 1
	
func generate_room(x, y, width, height):
	var newRoom = Room.new(Vector2(x+50,y+50), self,  "template", width, height)
	map_data.append(newRoom)

	
func getRandomPointInCircle(radius):
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	return [floor(r * cos(theta)), floor(r * sin(theta))]

func setThingy(x,y):
	set_cell(0, Vector2i(x,y), 0, Vector2i(5,0))
	
func deleteThingy(x,y):
	erase_cell(0, Vector2i(x,y))
	
	
func drawMap():
	var canDraw = true
	if roomsGenerated < room_count or !processRan:
		canDraw = false
	for room in map_data:
		if room.isOverlapping():
			canDraw = false
	print(canDraw)
	for room in map_data:
		if canDraw:
			room.drawRoom(get_parent())
		
	

func _draw():
	var canDraw = true
	if roomsGenerated < room_count or !processRan:
		canDraw = false
	for room in map_data:
		if(room.isOverlapping()):
			canDraw = false
	if canDraw == false:
		for data in old_data:
			deleteThingy(data.x, data.y)
		old_data.clear()
		for room in map_data:
			for x in range(0, room.roomWidth):
				for y in range(0, room.roomHeight):
					old_data.append(Vector2(x+room.position.x-(room.roomWidth/2), y+room.position.y-(room.roomHeight/2)))
					setThingy(x+room.position.x-(room.roomWidth/2), y+room.position.y-(room.roomHeight/2))
	else:
		for data in old_data:
			deleteThingy(data.x, data.y)
		old_data.clear()
		drawMap()
		

func _process(delta):
	processRan = true
	for room in map_data:
		accumulated_force = Vector2.ZERO
		var num_rooms = 0
		if room.has_overlapping_areas():
			for overlapping_area in room.get_overlapping_areas():
				if overlapping_area is Room:
					num_rooms += 1
					var distance = overlapping_area.position - room.position
					if distance.length() < desired_separation:
						var force = distance.normalized() * (distance.length() - desired_separation)
						accumulated_force += force
			if num_rooms > 0:
				accumulated_force /= num_rooms
			room.position += accumulated_force * delta
