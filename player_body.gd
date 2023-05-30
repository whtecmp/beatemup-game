extends CharacterBody2D

signal look_up
signal look_down
signal look_reg
signal attack_finished

const SPEED = 300.0;
const SLIDE_SPPED = 600;

var can_idle = true;
var is_attacking = false;
var is_fliped = false;
var is_sliding = false;
var can_slide = true;

func _ready():
	pass

func _physics_process(_delta):
	
	# Handle Slide
	if Input.is_action_just_pressed("a") and not is_attacking and can_slide:
		is_sliding = true;
		can_slide = false;
		$SlidingTimer.start()
	
	if Input.is_action_just_pressed("s") and not is_attacking and not is_sliding:
		$AnimatedSprite.play("Attack_1")
		can_idle = false;
		is_attacking = true;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"));
	direction = direction.normalized()
	if (direction.x or direction.y) and not is_attacking:
		var animation;
		var speed;
		if is_sliding:
			animation = "Slide"
			speed = SLIDE_SPPED
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
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if can_idle:
			$AnimatedSprite.play("Idle") 
	$AnimatedSprite.flip_h = is_fliped;
	var last_position = position;
	move_and_slide();
	var player = get_node("..");
	player.get_node("Detectors").position += position - last_position;


func _on_animated_sprite_animation_finished():
	print ("Hello WOrlld!")
	if $AnimatedSprite.animation == "Attack_1":
		$AnimatedSprite.play("Idle")
		can_idle = true;
		is_attacking = false;

func hit_by(who):
	get_node("..").hit_by(who);


func _on_sliding_timer_timeout():
	is_sliding = false
	$CanSlideTimer.start()


func _on_can_slide_timer_timeout():
	can_slide = true;
