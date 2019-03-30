extends Sprite

var speed = 0 #Player's speed
var score = 0; #Player's score
var tail = []; #Contains the reference to every tail part
var dotsRef; #Reference to every dots
var rocksRef; #Reference to every rocks
var isDead = false

#Add one part to the tail
func addTailPart():
	var index = tail.size();
	
	#Add to the tail array
	tail.push_back(preload("res://tailPart.scn").instance());

	#Init the part object with a reference to the previous part.
	if(index != 0):
		tail[index].init(tail[index-1]);
	else:
		tail[index].init(self);
	
	#Add to the scene
	get_parent().call_deferred("add_child",tail[index]);
	
	return

#Cut the tail from X place
func cutTail(from):
	var quantityToCut = range(from,tail.size());
	for i in quantityToCut:
		tail[tail.size()-1].destroy();
		tail.remove(tail.size()-1);
	return

func _ready():
	#Build the initial tail
	for i in 4:
		addTailPart();
	
	#Set reference to dots in the map
	dotsRef = get_parent().dots;
	
	#Set reference to rocks in the map
	rocksRef = get_parent().rocks;
	
	return

func _process(delta):
	if(isDead):
		if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
			get_parent().resetGame();
		return
	#Rotation when D or A pressed
	if(Input.is_key_pressed(KEY_D)):
		rotation += 0.01 * min(speed,8);
	elif(Input.is_key_pressed(KEY_A)):
		rotation -= 0.01 * min(speed,8);
	
	#chaning speed when W or S pressed or not
	if(Input.is_key_pressed(KEY_W)):
		if(speed<75) : speed += 2;
	elif(Input.is_key_pressed(KEY_S)):
		speed -= 4;
	else:
		speed -= 1;
	
	if(speed < 0): 
		speed = 0;
	
	#Updating the position
	#Also prevent from going outside the map
	var nextX = position.x + cos(rotation)*speed*delta;
	var nextY = position.y + sin(rotation)*speed*delta;
	
	if(nextX <= 182 && nextX >= -182):
		position.x = nextX;
	if(nextY <= 182 && nextY >= -182):
		position.y = nextY;
	
	#Eat dots
	for dot in dotsRef:
		if(position.distance_to(dot.position) < 5):
			dot.position = Vector2(rand_range(-182,182),rand_range(-182,182));
			addTailPart();
			score += 1*tail.size();
			get_parent().updateScoreTxt(score);
	
	#Cut the tail at X place if a rock is touching it
	for part in tail:
		for rock in rocksRef:
			if(part.position.distance_to(rock.position) < 7):
				cutTail(tail.find(part));
				rock.bounce();
	
	for rock in rocksRef:
		if(rock.position.distance_to(self.position) < 7):
			get_parent().get_node("UI/DeadScreen").visible = true;
			get_node("CPUParticles2D").visible = false;
			isDead = true;
			
	return
