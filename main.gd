extends Node2D

var last_player_pos;
var follow_player = Vector2(0, 0);
var screen_size;
var scroll_speed_1 = Vector2(0.15, 0.15);
var scroll_speed_2 = Vector2(0.25, 0.25);

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	last_player_pos = $Player/PlayerBody.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_camera()
	last_player_pos = $Player/PlayerBody.position

func update_camera():
	var canvas_transform = get_viewport().get_canvas_transform()
	var player_offset = last_player_pos - $Player/PlayerBody.position
	player_offset.x *= follow_player.x
	player_offset.y *= follow_player.y
	canvas_transform[2] += player_offset
	get_viewport().set_canvas_transform(canvas_transform)

func _on_player_player_change_hit_points(new_value):
	$FollowView/HUD/Label.text = str(new_value)

func _on_camera_controller_player_entered_x():
	follow_player += Vector2(1, 0);

func _on_camera_controller_player_exited_x():
	follow_player -= Vector2(1, 0);

func _on_camera_controller_player_entered_y():
	follow_player += Vector2(0, 1);

func _on_camera_controller_player_exited_y():
	follow_player -= Vector2(0, 1);
