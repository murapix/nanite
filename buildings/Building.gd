class_name Building extends Node2D

signal build;

@export var functional: bool = true;
@export var id: BuildingData.buildingIDs;
@export var buildDisplay: CanvasItem;
@export var buildProgressBar: ProgressBarHandler;
@export var runDisplay: CanvasItem;

var buildCost: Dictionary[ResourceData.resourceID, float];
var built = false;

func finishBuild():
	buildDisplay.visible = false;
	runDisplay.visible = true;
	built = true;
	build.emit();

func _ready():
	if not functional: finishBuild(); return;
	buildCost = {};
	for resource in BuildingData.buildings[id].cost:
		buildCost[resource] = float(BuildingData.buildings[id].cost[resource]);

func _process(delta):
	if not functional: finishBuild(); return;
	if built: return;

	var remainingBuild = 1;
	for resource in buildCost:
		var amount = min(buildCost[resource], remainingBuild, delta);
		if amount <= 0:
			continue;
		amount = requestResource(resource, amount);
		buildCost[resource] -= amount;
		remainingBuild -= amount;
		buildProgressBar.setFillFromResources(buildCost, BuildingData.buildings[id].cost, true);
		if remainingBuild <= 0:
			finishBuild();
			return;

func requestResource(_resource: ResourceData.resourceID, amount: int) -> int:
	return amount;
