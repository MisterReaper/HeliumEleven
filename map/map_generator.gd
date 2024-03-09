extends TileMap

var room_count = 40      # Number of rooms to generate
var radius = 50
var roomSize = 10  # 22 x 14
var widthRoom = 22
var heightRoom = 14
var bossRoomSize = 15
var numBossRooms = 5
var desired_separation = 27
var map_data = []  # Stores generated map information (e.g., room positions, shapes)
var accumulated_force = Vector2.ZERO
var old_data = []
var roomsGenerated = 0
var processRan = false
var alreadyDrawn = false
var roomCamera
var player
var start
var boss
var end

	
func _ready():
	generate_map()
	player = get_node("../player")

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
		if alreadyDrawn == false:
			for data in old_data:
				deleteThingy(data.x, data.y)
			old_data.clear()
			calculateNeighbors()
			calculateStartAndEndRoom()
			drawMap()
			alreadyDrawn = true
			map_data[start].setFocus()
		
		
		
func drawSingleRoom(room):
	room.drawRoom(get_parent())

func calculateNeighbors():
	for roomOrigin in map_data:
		roomOrigin.checkBorders(map_data)
				

func calculateStartAndEndRoom():
	var visitedNeighbors = []
	var stillLookingForStartRoom = true
	while stillLookingForStartRoom:
		start = randi() % map_data.size()
		visitedNeighbors = calculatePossiblePath(map_data[start], visitedNeighbors)
		if visitedNeighbors.size() > 3:
			stillLookingForStartRoom = false
	end = randi() % map_data.size()
	while end == start:
		end = randi() % map_data.size()
	boss = randi() % map_data.size()
	while boss == start:
		boss = randi() % map_data.size()
	roomCamera = map_data[start].camera
	player.position.x = map_data[start].position.x*16+11*16
	player.position.y = map_data[start].position.y*16+7*16
	map_data[start].template = preload("res://map/roomTemplates/room1.tscn")
	

func calculatePossiblePath(startRoom, visited):
	visited.append(startRoom)
	if startRoom.topRightNeighbor != null && startRoom.topRightNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.topRightNeighbor, visited)
	if startRoom.topLeftNeighbor != null && startRoom.topLeftNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.topLeftNeighbor, visited)
	if startRoom.rightTopNeighbor != null && startRoom.rightTopNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.rightTopNeighbor, visited)
	if startRoom.rightDownNeighbor != null && startRoom.rightDownNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.rightDownNeighbor, visited)
	if startRoom.downRightNeighbor != null && startRoom.downRightNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.downRightNeighbor, visited)
	if startRoom.downLeftNeighbor != null && startRoom.downLeftNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.downLeftNeighbor, visited)
	if startRoom.leftDownNeighbor != null && startRoom.leftDownNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.leftDownNeighbor, visited)
	if startRoom.leftTopNeighbor != null && startRoom.leftTopNeighbor not in visited:
		visited = calculatePossiblePath(startRoom.leftTopNeighbor, visited)
	return visited

func _process(delta):
	if alreadyDrawn == false:
		_draw()
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
