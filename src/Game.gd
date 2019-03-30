extends Node2D

var dots = []; #Contains references to every dots
var rocks = []; #Contains references to every rocks
var time = 0; #Time since the game started (Seconds)
var lastTime = 0; #Last time a rock has been added

func _ready():
	VisualServer.set_default_clear_color(Color(0.25,0.17,0.11));
	
	#Create 4 dots
	for i in range(4):
		dots.push_back(preload("res://dot.scn").instance());
		dots[i].position = Vector2(rand_range(-182,182),rand_range(-182,182));
		call_deferred("add_child",dots[i]);
	
	#Create 5 rocks
	for i in range(3):
		addRock();
	
	return

func resetGame():
	get_tree().reload_current_scene();
	return

#Add a new rock
func addRock():
	var index = rocks.size();
	rocks.push_back(preload("res://rock.scn").instance());
	call_deferred("add_child",rocks[index]);
	rocks[index].respawn();
	return

#Update the text UI
func updateScoreTxt(score):
	var scoretxt = get_node("UI/ScoreTxt");
	scoretxt.text = "Score: " + str(score);
	return

func _process(delta):
	#Add a new rock every 15 seconds
	time+=delta;
	var timeRounded = round(time);
	if(int(timeRounded) % 15 == 0):
		if(timeRounded != lastTime):
			addRock();
		lastTime = timeRounded;
		
	return