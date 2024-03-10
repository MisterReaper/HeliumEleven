extends Area2D

class_name Room

var template
var collShape
var roomWidth
var roomHeight
var neighbor = []
var topLeftNeighbor = null
var topRightNeighbor = null 
var rightTopNeighbor = null
var rightDownNeighbor = null
var downLeftNeighbor = null
var downRightNeighbor = null
var leftDownNeighbor = null
var leftTopNeighbor = null
var camera

func _init(startPos, scene, template, width, height):
	roomWidth = width
	roomHeight = height
	position = startPos
	self.template = preload("res://map/roomTemplates/room2.tscn")
	scene.add_child(self)
	collShape = CollisionShape2D.new()
	add_child(collShape)
	var recShape = RectangleShape2D.new()
	collShape.shape = recShape
	collShape.shape.extents = Vector2(roomWidth/2,roomHeight/2)
	camera = Camera2D.new()
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT


func isOverlapping():
	for area in get_overlapping_areas():
		if area is Room:
			return true
	return false 
	
func drawRoom(root_node):
	var roomInstance = template.instantiate()
	roomInstance.position.x = roundi(position.x) *16
	roomInstance.position.y = roundi(position.y) *16 
	root_node.add_child(roomInstance)
	
	roomInstance.add_child(camera)
	camera.position.y += 1

func checkBorders(possibleAdjecentRooms):
	var startPos = Vector2.ZERO
	startPos.x = position.x - roomWidth / 2
	startPos.y = position.y - roomHeight / 2 -1
	for i in range(0, roomWidth):
		startPos.x += i
		for possibleRoom in possibleAdjecentRooms:
			if possibleRoom != self && possibleRoom.isInside(startPos):
				if topLeftNeighbor == null:
					topLeftNeighbor = possibleRoom
				if topLeftNeighbor != null && possibleRoom != topLeftNeighbor && topRightNeighbor == null:
					topRightNeighbor = possibleRoom
	startPos.x += 1
	startPos.y += 1	
	for i in range(0, roomHeight):
		startPos.y += i
		for possibleRoom in possibleAdjecentRooms:
			if possibleRoom != self && possibleRoom.isInside(startPos):
				if rightTopNeighbor == null:
					rightTopNeighbor = possibleRoom
				if rightTopNeighbor != null && possibleRoom != rightTopNeighbor && rightDownNeighbor == null:
					rightDownNeighbor = possibleRoom
	startPos.x -= 1
	startPos.y += 1
	for i in range(0, roomWidth):
		startPos.x -= i
		for possibleRoom in possibleAdjecentRooms:
			if possibleRoom != self && possibleRoom.isInside(startPos):
				if downRightNeighbor == null:
					downRightNeighbor = possibleRoom
				if downRightNeighbor != null && possibleRoom != downRightNeighbor && downLeftNeighbor == null:
					downLeftNeighbor = possibleRoom
	startPos.x -= 1
	startPos.y -= 1
	for i in range(0, roomHeight):
		startPos.y -= i
		for possibleRoom in possibleAdjecentRooms:
			if possibleRoom != self && possibleRoom.isInside(startPos):
				if leftDownNeighbor == null:
					leftDownNeighbor = possibleRoom
				if leftDownNeighbor != null && possibleRoom != leftDownNeighbor && leftTopNeighbor == null:
					leftTopNeighbor = possibleRoom
		
func setFocus():
	camera.make_current()
	

func isInside(checkPosition):
	return (position.x - roomWidth/2) <= checkPosition.x && (position.x + roomWidth/2) >= checkPosition.x && (position.y - roomHeight/2) <= checkPosition.y && (position.y + roomHeight/2) >= checkPosition.y
