@tool class_name Crafter extends Node

@export var building: Building:
	set(value): building = value; update_configuration_warnings();
@export var inputs: ResourceStore:
	set(value): inputs = value; update_configuration_warnings();
@export var outputs: ResourceStore:
	set(value): outputs = value; update_configuration_warnings();
@export var progressBar: ProgressBarHandler;

var recipeIDs: Array[RecipeData.recipeID];
var selectedRecipe: RecipeData.BaseRecipe;
var inputSizeMulti: int;
var outputSizeMulti: int;
var selectedRecipeID: int = 0:
	set(value):
		selectedRecipeID = value;
		selectedRecipe = RecipeData.recipes[self.recipeIDs[value]];
		for resource in selectedRecipe.inputs:
			inputs.limits[resource] = selectedRecipe.inputs[resource] * inputSizeMulti;
		for resource in selectedRecipe.outputs:
			outputs.limits[resource] = selectedRecipe.outputs[resource] * outputSizeMulti;

var remainingCraftTime = 0;

func canCraft() -> bool:
	if building == null: return false;
	if 'built' not in building: return false;
	if building.built: return false;
	if selectedRecipeID < 0: return false;
	if selectedRecipeID >= recipeIDs.size(): return false;
	
	if remainingCraftTime > 0: return true;
	
	for resource in selectedRecipe.outputs:
		if outputs.resources.get_or_add(resource, 0) + selectedRecipe.outputs[resource] > outputs.limits.get_or_add(resource, 0):
			return false;
	for resource in selectedRecipe.inputs:
		if selectedRecipe.inputs[resource] > inputs.resources.get_or_add(resource, 0):
			return false;
	
	return true;

func tryCraft(delta) -> void:
	if remainingCraftTime <= 0:
		if canCraft():
			remainingCraftTime = selectedRecipe.duration;
			for resource in selectedRecipe.inputs:
				inputs.resources[resource] -= selectedRecipe.inputs[resource];
		return;
	
	remainingCraftTime -= delta;
	if remainingCraftTime <= 0:
		remainingCraftTime = 0;
		progressBar.setFillPercentage(remainingCraftTime / selectedRecipe.duration, true);
		for resource in selectedRecipe.outputs:
			outputs.resources[resource] += selectedRecipe.outputs[resource];
	else: progressBar.setFillPercentage(0);

func _process(delta: float) -> void:
	tryCraft(delta);

func _ready() -> void:
	pass;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = [];
	if building == null: warnings.append("Must reference a Building");
	if inputs == null: warnings.append("Must reference an input ResourceStore");
	if outputs == null: warnings.append("Must reference an output ResourceStore");
	return warnings;
