class_name RecipeData extends Resource

class BaseRecipe:
	var inputs: Dictionary[ResourceData.resourceID, int];
	var outputs: Dictionary[ResourceData.resourceID, int];
	var duration: int;
	
	func _init(inputs: Dictionary[ResourceData.resourceID, int],
			   outputs: Dictionary[ResourceData.resourceID, int],
			   duration: int):
		self.inputs = inputs;
		self.outputs = outputs;
		self.duration = duration;
	
	func isAvailable(recipeId: RecipeData.recipeID, building: Building) -> bool:
		match BuildingData.buildings[building.id].recipes[recipeId]:
			true: return true;
			{ 'research': var research }:
				if research is ResearchData.researchIDs:
					return true;
				return false;
			_: return false;


enum recipeID {
	NANITE_TO_SCRAP,
	SCRAP_TO_BASIC_PLATES,
	BASIC_PLATES_TO_BASIC_CIRCUITS
}
static var recipes: Dictionary[recipeID, BaseRecipe] = {
	recipeID.NANITE_TO_SCRAP: BaseRecipe.new(
		{ ResourceData.resourceID.SCRAP: 1 },
		{ ResourceData.resourceID.NANITES: 1 },
		1
	),
	recipeID.SCRAP_TO_BASIC_PLATES: BaseRecipe.new(
		{ ResourceData.resourceID.NANITES: 10 },
		{ ResourceData.resourceID.BASIC_PLATES: 1 },
		10
	),
	recipeID.BASIC_PLATES_TO_BASIC_CIRCUITS: BaseRecipe.new(
		{ ResourceData.resourceID.BASIC_PLATES: 2 },
		{ ResourceData.resourceID.BASIC_CIRCUITS: 1 },
		10
	)
}
