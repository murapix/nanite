class_name Building extends Node2D

@export var id: BuildingData.buildingIDs;
var buildCost: Dictionary[ResourceData.resourceID, int];
var built = false;

func _ready():
	buildCost = BuildingData.buildings[id].cost.duplicate();

func _process(delta):
	if built:
		return;
	
	var remainingBuild = 1;
	for resource in buildCost:
		var amount = min(buildCost[resource], remainingBuild, delta);
		if amount <= 0:
			continue;
		amount = requestResource(resource, amount);
		buildCost[resource] -= amount;
		remainingBuild -= amount;
		if remainingBuild <= 0:
			built = true;
			return;

func requestResource(_resource: ResourceData.resourceID, amount: int) -> int:
	return amount;
