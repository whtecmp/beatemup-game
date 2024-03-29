extends CharacterBody2D

signal look_up
signal look_down
signal look_reg
signal attack_finished

const SPEED = 450.0;
const SLIDE_SPPED_FACTOR = 2;

var can_idle = true;
var is_initiating_attack = false;
var attack_is_on = false;
var is_fliped = false;
var is_sliding = false;
var can_slide = true;
var is_dying = false;

func _physics_process(delta):
	
	if not is_dying:
		# Handle Slide
		if Input.is_action_just_pressed("a") and not is_initiating_attack and can_slide:
			is_sliding = true;
			can_slide = false;
			$SlidingTimer.start()
		
		if Input.is_action_just_pressed("s") and not is_initiating_attack and not is_sliding:
			$AnimatedSprite.play("Attack_1")
			can_idle = false;
			is_initiating_attack = true;
			$InitiateAttackTimer.start();

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"));
		direction = direction.normalized()
		if (direction.x or direction.y or is_sliding) and not is_initiating_attack:
			var animation;
			var speed;
			if is_sliding:
				animation = "Slide"
				speed = SLIDE_SPPED_FACTOR * SPEED
				if direction.x == 0 and direction.y == 0:
					direction = Vector2(1, 0) if not is_fliped else Vector2(-1, 0)
			else:
				animation = "Run"
				speed = SPEED
			velocity = direction * speed
			$AnimatedSprite.play(animation)
			if direction.x < 0:
				is_fliped = true;
			elif direction.x > 0:
				is_fliped = false;
		else:
			velocity.x = 0 # move_toward(velocity.x, 0, SPEED)
			velocity.y = 0 # move_toward(velocity.y, 0, SPEED)
			if can_idle:
				$AnimatedSprite.play("Idle") 
		$AnimatedSprite.flip_h = is_fliped;
	var last_position = position;
	move_and_collide(velocity * delta);
	var player = get_node("..");
	player.get_node("Detectors").position += position - last_position;


func _on_animated_sprite_animation_finished():
	if $AnimatedSprite.animation == "Attack_1":
		$AnimatedSprite.play("Idle")
		can_idle = true;
		is_initiating_attack = false;
		attack_is_on = false;
	elif $AnimatedSprite.animation == "Dying":
		get_node("..").die();

func hit_by(who):
	get_node("..").hit_by(who);


func _on_sliding_timer_timeout():
	is_sliding = false
	$CanSlideTimer.start()


func _on_can_slide_timer_timeout():
	can_slide = true;


func _on_initiate_attack_timer_timeout():
	attack_is_on = true;
