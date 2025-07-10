extends Camera2D

const MAX_ZOOM = Vector2(1, 1);
const MIN_ZOOM = Vector2(0.05, 0.05);
const ZOOM_SPEED = Vector2(1, 1) - Vector2(0.1, 0.1);

func _process(_delta):
	if Input.is_action_just_released("Zoom In") and self.zoom < MAX_ZOOM:
		zoom = lerp(zoom, zoom / ZOOM_SPEED, 1);
		await get_tree().create_timer(0.1).timeout;
	if Input.is_action_just_released("Zoom Out") and self.zoom > MIN_ZOOM:
		zoom = lerp(zoom, zoom * ZOOM_SPEED, 1);
		await get_tree().create_timer(0.1).timeout;
	#if Input.is_action_just_released("Move Left"):
		#offset.x = lerp(offset.x, offset.x - 100, 1);
		#await get_tree().create_timer(0.1).timeout;
	#if Input.is_action_just_released("Move Right"):
		#offset.x = lerp(offset.x, offset.x + 100, 1);
		#await get_tree().create_timer(0.1).timeout;
	#if Input.is_action_just_released("Move Up"):
		#offset.y = lerp(offset.y, offset.y - 100, 1);
		#await get_tree().create_timer(0.1).timeout;
	#if Input.is_action_just_released("Move Down"):
		#offset.y = lerp(offset.y, offset.y + 100, 1);
		#await get_tree().create_timer(0.1).timeout;
	#if Input.is_action_just_released("Reset to Core"):
		#offset = lerp(offset, Vector2(0,0), 1);
		#await get_tree().create_timer(1).timeout;
