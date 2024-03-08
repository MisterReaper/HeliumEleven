extends Area2D

class_name Room

var template
var collShape
var roomWidth
var roomHeight

func _init(startPos, scene, template, width, height):
	roomWidth = width
	roomHeight = height
	position = startPos
	self.template = preload("res://map/roomTemplates/room1.tscn")
	scene.add_child(self)
	collShape = CollisionShape2D.new()
	add_child(collShape)
	var recShape = RectangleShape2D.new()
	collShape.shape = recShape
	collShape.shape.extents = Vector2(roomWidth/2,roomHeight/2)


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

	



