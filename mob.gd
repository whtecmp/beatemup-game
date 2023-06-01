extends CharacterBody2D


const SPEED = 200.0

# enum {TOO_CLOSE_LEFT, TOO_CLOSE_RIGHT, TOO_FAR, LEFT, RIGHT, UP, DOWN, TOO_CLOSE_UP, TOO_CLOSE_DOWN }

enum {LEFT, RIGHT}

var wants_attack = Vector2(0, 0);
var is_attacking = false;
var attack_idle = false;
var can_idle = true;
var walk = false;
var direction = Vector2(0, 0);
var play_animation;
var stop_animation;
var flip;
var look_direction = RIGHT;
var attack_is_on = false;
var whoami;

func assess_relative_position_to_objective(objective, min_distance_threshold_x, min_distance_threshold_y, max_distance_threshold):
	if not objective:
		return Vector2(0, 0);
	var x_distance_from_object = global_position.x - objective.global_position.x;
	var y_distance_from_object = global_position.y - objective.global_position.y;
	var asses_func = func (distance_from_object, min_distance_threshold):
		if min_distance_threshold < distance_from_object and distance_from_object < max_distance_threshold:
			return -1;
		elif -min_distance_threshold > distance_from_object and distance_from_object > -max_distance_threshold:
			return 1;
		elif -min_distance_threshold < distance_from_object and distance_from_object < 0:
			return -2;
		elif 0 < distance_from_object and distance_from_object < min_distance_threshold:
			return 2;
		else:
			return 0;
	return Vector2(asses_func.call(x_distance_from_object, min_distance_threshold_x), asses_func.call(y_distance_from_object, min_distance_threshold_y))

func manage_attack():
	if attack_is_on:
		var in_range_bodies;
		if look_direction == RIGHT:
			in_range_bodies = get_node("../Detectors/AttackDetectorRight").get_overlapping_bodies()
		elif look_direction == LEFT:
			in_range_bodies = get_node("../Detectors/AttackDetectorLeft").get_overlapping_bodies()
		for body in in_range_bodies:
			if body.has_method("hit_by"):
				body.hit_by(whoami)

func _physics_process(_delta):
	walk = true;
	wants_attack = Vector2(0, 0)
	var relative_position_to_objective = assess_relative_position_to_objective(get_tree().get_root().get_node("Main/Player/PlayerBody"), 120, 20, 1000);
	{
		-1: func (_self):
			_self.direction.x = -1,
		1: func (_self):
			_self.direction.x = 1,
		0: func (_self):
			_self.walk = false;,
		-2: func (_self):
			_self.direction.x = 0;
			_self.wants_attack.x = 1;,
		2: func (_self):
			_self.direction.x = 0;
			_self.wants_attack.x = 1;
	}[int(relative_position_to_objective.x)].call(self)
	{
		-1: func (_self):
			_self.direction.y = -1,
		1: func (_self):
			_self.direction.y = 1,
		0: func (_self):
			_self.walk = false;,
		-2: func (_self):
			_self.direction.y = 0;
			_self.wants_attack.y = 1;,
		2: func (_self):
			_self.direction.y = 0;
			_self.wants_attack.y = 1;
	}[int(relative_position_to_objective.y)].call(self)
	
	if wants_attack.x and wants_attack.y and not is_attacking and not attack_idle:
		walk = false;
		wants_attack = Vector2(0, 0);
		play_animation.call("Attack");
		is_attacking = true;
		can_idle = false;
		attack_idle = true;
		$AttackTimer.start()
	
	# As good practice, you should replace UI actions with custom gameplay actions.
	if walk and not is_attacking:
		if wants_attack.x:
			direction.x = -1;
		velocity = direction.normalized() * SPEED
		play_animation.call("Run")
	else:
		if can_idle:
			play_animation.call("Idle")
		velocity.x = 0 # move_toward(velocity.x, 0, SPEED)
		velocity.y = 0 # move_toward(velocity.y, 0, SPEED)
	if walk and not is_attacking and direction.x > 0:
		flip.call(false);
	elif walk and not is_attacking and direction.x < 0:
		flip.call(true);

	manage_attack()

	if velocity.x < 0:
		look_direction = LEFT;
	elif velocity.x > 0: 
		look_direction = RIGHT;
	var last_position = position;
	move_and_slide();
	var mob = get_node("..");
	mob.get_node("Detectors").position += position - last_position;

func attack_finished():
	play_animation.call("Idle")
	can_idle = true;
	is_attacking = false;


func hit_by(who):
	get_node("..").hit_by(who);

func _on_attack_timer_timeout():
	attack_idle = false;

func _on_attack_is_on_timer_timeout():
	attack_is_on = false;