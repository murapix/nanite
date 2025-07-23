extends Camera2D

const MAX_ZOOM = Vector2(5, 5);
const MIN_ZOOM = Vector2(0.25, 0.25);
const ZOOM_SPEED = 0.9;

func changeZoom(delta: float):
	var oldMousePos = get_global_mouse_position();
	zoom *= delta;
	var newMousePos = get_global_mouse_position();
	position += oldMousePos - newMousePos;

func _process(_delta):
	if get_viewport_rect().has_point(get_viewport().get_mouse_position()):
		if Input.is_action_just_released("Zoom In") and self.zoom < MAX_ZOOM:
			changeZoom(1/ZOOM_SPEED);
			await get_tree().create_timer(0.1).timeout;
		if Input.is_action_just_released("Zoom Out") and self.zoom > MIN_ZOOM:
			changeZoom(ZOOM_SPEED);
			await get_tree().create_timer(0.1).timeout;
