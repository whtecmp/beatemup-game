extends Node2D

signal player_change_hit_points(new_value)

var hits = 100;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PlayerBody.attack_is_on:
		var in_range_bodies;
		if not $PlayerBody.is_fliped:
			in_range_bodies = $Detectors/AttackDetectorRight.get_overlapping_bodies()
		else:
			in_range_bodies = $Detectors/AttackDetectorLeft.get_overlapping_bodies()
		for body in in_range_bodies:
			if body.has_method("hit_by"):
				body.hit_by("player")
	if hits <= 0:
		$PlayerBody/AnimatedSprite.play("Dying")
		$PlayerBody.is_dying = true;


func die():
	visible = false;

func hit_by(who):
	if who == "basic_enemy_soldier":
		hits -= 2;
		emit_signal("player_change_hit_points", hits);
