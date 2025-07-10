@tool class_name Crafter extends Node

@export var building: Building:
	set(value): building = value; update_configuration_warnings();
@export var inputs: ResourceStore:
	set(value): inputs = value; update_configuration_warnings();
@export var outputs: ResourceStore:
	set(value): outputs = value; update_configuration_warnings();

var recipeIDs: Array[RecipeData.recipeID];
var inputSizeMulti: int;
var outputSizeMulti: int;
var selectedRecipeID: int = 0:
	set(value):
		selectedRecipeID = value;
		var recipeData = RecipeData.recipes[self.recipeIDs[value]];
		for resource in recipeData.inputs:
			inputs.limits[resource] = recipeData.inputs[resource] * inputSizeMulti;
		for resource in recipeData.outputs:
			outputs.limits[resource] = recipeData.outputs[resource] * outputSizeMulti;

var remainingCraftTime = 0;

func canCraft() -> bool:
	if 'built' not in building: return false;
	if building.built: return false;
	if selectedRecipeID < 0: return false;
	if selectedRecipeID >= recipeIDs.size(): return false;
	
	if remainingCraftTime > 0: return true;
	
	var selectedRecipe = recipeIDs[selectedRecipeID];
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
			var selectedRecipe = recipeIDs[selectedRecipeID];
			remainingCraftTime = selectedRecipe.duration;
			for resource in selectedRecipe.inputs:
				inputs.resources[resource] -= selectedRecipe.inputs[resource];
		return;
	
	remainingCraftTime -= delta;
	if remainingCraftTime <= 0:
		remainingCraftTime = 0;
		var selectedRecipe = recipeIDs[selectedRecipeID];
		for resource in selectedRecipe.outputs:
			outputs.resources[resource] += selectedRecipe.outputs[resource];

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
