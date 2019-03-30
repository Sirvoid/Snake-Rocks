extends Sprite

var dir = Vector2(0,0); #Direction the rock is going

#Make the rock respawn
func respawn():
	#Set a random direction
	dir.x = round(rand_range(-1,1));
	dir.y = round(rand_range(-1,1));
	if(dir.x == 0 && dir.y == 0):
		dir.y = 1;
		
	#Random spawn
	randSpawnPos();
	return

#Spawn to a random location on the sides
func randSpawnPos():
	var side = round(rand_range(0,4));
	var distOnSide = rand_range(0,200);
	
	if(side == 0):
		position.x = -200;
		position.y = distOnSide;
	if(side == 1):
		position.x = 200;
		position.y = distOnSide;
	if(side == 3):
		position.x = distOnSide;
		position.y = -200;
	if(side == 4):
		position.x = distOnSide;
		position.y = 200;
	return

#Make the rock bounce
func bounce():
	dir = -dir;
	return

func _ready():
	respawn();
	return

func _process(delta):
	#Move and respawn when edges reached
	rotation+=0.02;
	position += dir*110*delta;
	if(position.x > 200 || position.x < -200 || position.y > 200 || position.y < -200):
		respawn();
	return
