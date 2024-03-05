extends Area2D

class_name Room

var template
var collShape
var roomSize

func _init(startPos, scene, template, size):
	roomSize = size
	position = startPos
	self.template = template
	scene.add_child(self)
	collShape = CollisionShape2D.new()
	add_child(collShape)
	var recShape = RectangleShape2D.new()
	collShape.shape = recShape
	collShape.shape.extents = Vector2(roomSize/2,roomSize/2)


func isOverlapping():
	for area in get_overlapping_areas():
		if area is Room:
			return true
	return false 

	



