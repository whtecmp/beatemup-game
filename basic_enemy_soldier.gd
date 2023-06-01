extends Node2D

var soldier_type = "Soldier";

func get_animation_node(_self):
	return get_node("Mob/"+_self.soldier_type+"Animation")

func flip(to_flip):
	get_animation_node(self).flip_h = to_flip;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _self = self;
	get_animation_node(self).visible = true;
	$Mob.stop_animation = func():
		get_animation_node(_self).stop();
	$Mob.play_animation = func(anim, custom_speed = 1.0, backwards = false):
		custom_speed = custom_speed * (-1 if backwards else 1);
		get_animation_node(_self).play(anim, custom_speed, backwards);
	$Mob.flip = flip;
	$Mob.whoami = "basic_enemy_soldier"

func hit_by(who):
	if who == "player":
		$Mob.is_dying = true;

func _on_soldier_animation_animation_finished():
	if get_animation_node(self).animation == "Attack":
		$Mob.attack_finished();
	elif get_animation_node(self).animation == "Dying":
		$Mob.die();
