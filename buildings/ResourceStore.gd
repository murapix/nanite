class_name ResourceStore extends Node

@export_category("Storage Data")
@export var isOutput: bool = false;
@export var limits: Dictionary[ResourceData.resourceID, int] = {};
@export var resources: Dictionary[ResourceData.resourceID, float] = {};

@export_category("Graphical Options")
@export var fillBar: ProgressBarHandler;

func getRemainingSpace(resource: ResourceData.resourceID):
	return limits.get(resource, 0) - resources.get(resource, 0);

func _process(_delta):
	if fillBar == null: return;
	fillBar.setFillFromResources(resources, limits);
