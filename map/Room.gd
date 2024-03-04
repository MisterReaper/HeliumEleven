extends Area2D

class_name Room

var template
var collShape

func _init(startPos, scene, template, size):
	position = startPos
	self.template = template
	scene.add_child(self)
	collShape = CollisionShape2D.new()
	add_child(collShape)
	var recShape = RectangleShape2D.new()
	collShape.shape = recShape
	collShape.shape.extents = Vector2(size/2,size/2)


func isOverlapping():
	for area in get_overlapping_areas():
		if area is Room:
			return true
	return false 

	

func _my_area_entered(area: Room):
	
	if(overlaps_area(area)):
		var distance_vector = position - area.position
		if(distance_vector.x < 0):
			position.x-=1
		if(distance_vector.x > 0):
			position.x+=1
		if(distance_vector.y < 0):
			position.y-=1
		if(distance_vector.y > 0):
			position.y+=1
		if(distance_vector.x == 0 && distance_vector.y == 0):
			position.x+=1	


