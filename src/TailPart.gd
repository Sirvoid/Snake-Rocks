extends Sprite

var parentPart;
var dead = false;

func init(parentPart):

	#Get parent body part reference
	self.parentPart = parentPart;
	self.position = parentPart.position;
	
	return

func destroy():
	dead = true;
	return

func _process(delta):
	
	if(dead == true): 
		modulate = Color(1, 1, 1, 0.5);
		return;
	#Look at the other part
	rotation = position.angle_to_point(parentPart.position);
	
	#Get the distance with the other part
	var dist = position.distance_to(parentPart.position);
	
	#Move closer to the other part but keep a certain distance
	if(dist > 7): 
		position += (parentPart.position - position) * dist * delta;
	
	#Prevent bugs
	if(dist > 1000):
		position = parentPart.position;
	
	return
