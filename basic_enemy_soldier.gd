extends Node2D

func flip(to_flip):
	$Mob/SoldierAnimation.flip_h = to_flip;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _self = self;
	$Mob.stop_animation = func():
		_self.get_node("Mob/SoldierAnimation").stop();
	$Mob.play_animation = func(anim, custom_speed = 1.0, backwards = false):
		custom_speed = custom_speed * (-1 if backwards else 1);
		_self.get_node("Mob/SoldierAnimation").play(anim, custom_speed, backwards);
	$Mob.flip = flip;
	$Mob.whoami = "basic_enemy_soldier"

func hit_by(who):
	if who == "player":
		$Mob.is_dying = true;

func _on_soldier_animation_animation_finished():
	if $Mob/SoldierAnimation.animation == "Attack":
		$Mob.attack_finished();
	elif $Mob/SoldierAnimation.animation == "Dying":
		$Mob.die();
