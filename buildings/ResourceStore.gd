class_name ResourceStore extends Node

@export_category("Storage Data")
@export var isOutput: bool = false;
@export var limits: Dictionary[ResourceData.resourceID, int] = {};
@export var resources: Dictionary[ResourceData.resourceID, float] = {};

@export_category("Graphical Options")
@export var fillImage: Sprite2D:
	set(newImage):
		fillImage = newImage;
		fillImageBounds = Rect2(newImage.region_rect);
var fillImageBounds: Rect2;

func getFillLevel():
	var amount = resources.values().reduce(func(sum, val) -> float: return sum+val, 0);
	var total = max(limits.values().reduce(func(sum, val) -> int: return sum+val, 0), 1);
	return amount/total;

func updateSpriteBounds():
	var fillLevel = getFillLevel();
	
	var newHeight = fillImageBounds.size.y * fillLevel;
	var newY = fillImageBounds.position.y + fillImageBounds.size.y - newHeight;
	var newOffset = (fillImageBounds.size.y - newHeight)/2;
	
	fillImage.region_rect.size.y = newHeight;
	fillImage.region_rect.position.y = newY;
	fillImage.offset.y = newOffset;

func _process(_delta):
	updateSpriteBounds();
