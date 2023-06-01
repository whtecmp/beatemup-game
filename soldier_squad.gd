extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var old_type = get_node("SecondEnemySoldier"+str(i+1)).soldier_type;
		get_node("SecondEnemySoldier"+str(i+1)).soldier_type = "Soldier2";
		get_node("SecondEnemySoldier"+str(i+1)).get_node("Mob/"+old_type+"Animation").visible = false;
		get_node("SecondEnemySoldier"+str(i+1)).get_node("Mob/Soldier2Animation").visible = true;
