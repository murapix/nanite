extends Node2D

@export var building: Building;
@export var researchStore: ResourceStore;
@export var animator: AnimationPlayer;

var processingTime = 0;
var processingIndex = 0;
var toProcess = [
	{ 'research': ResourceData.resourceID.CRAFTING_RESEARCH, 'amount': 0 },
	{ 'research': ResourceData.resourceID.BUILDING_RESEARCH, 'amount': 0 },
	{ 'research': ResourceData.resourceID.FIGHTING_RESEARCH, 'amount': 0 },
	{ 'research': ResourceData.resourceID.CORRUPTION_RESEARCH, 'amount': 0 },
	{ 'research': ResourceData.resourceID.STRANGE_RESEARCH, 'amount': 0 }
]

func finishProcessing(process):
	var research = process.research;
	var toMove = min(1, process.amount, researchStore.getRemainingSpace(research));
	researchStore.resources[research] += toMove;
	process.amount -= toMove;

func findNextProcess(currentIndex: int) -> int:
	for i in range(currentIndex+1, currentIndex+1+toProcess.size()):
		var nextIndex = i % toProcess.size();
		var nextProcess = toProcess[nextIndex];
		if nextProcess.amount < 1: continue;
		if researchStore.getRemainingSpace(nextProcess.research) < 1: continue;
		return nextIndex;
	return -1;

func _process(delta: float) -> void:
	if processingTime > 0:
		processingTime -= delta;
		if processingTime <= 0:
			processingTime = 0;
			finishProcessing(toProcess[processingIndex]);
			
	if processingTime == 0:
		var nextIndex = findNextProcess(processingIndex);
		if nextIndex >= 0:
			processingTime = 1;
			processingIndex = nextIndex;
			animator.play();
