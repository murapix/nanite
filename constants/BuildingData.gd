class_name BuildingData extends Resource

class BaseBuildingBuilder:
	var building: BaseBuilding = BaseBuilding.new();
	
	func _init(node: PackedScene, cost: Dictionary[ResourceData.resourceID, int]):
		building.node = node;
		building.cost = cost;

	func withRecipes(recipes: Dictionary[RecipeData.recipeID, Variant],
					 inputStoreSize: int = 1, outputStoreSize: int = 1) -> BaseBuildingBuilder:
		building.recipes = recipes;
		building.inputStoreSize = inputStoreSize;
		building.outputStoreSize = outputStoreSize;
		return self;

	func build(): return building;

class BaseBuilding:
	var cost: Dictionary[ResourceData.resourceID, int];
	var recipes: Dictionary[RecipeData.recipeID, Variant];
	var inputStoreSize: int;
	var outputStoreSize: int;
	var node: PackedScene;
	
	func instantiate(): return node.instantiate();

enum buildingIDs {
	CORE,
	EXTRACTOR,
	ROUTER,
	FOUNDRY,
	ANALYZER,
	RESEARCHER,
	BORE
}
static var buildings: Dictionary[buildingIDs, BaseBuilding] = (func() -> Dictionary[buildingIDs, BaseBuilding]: return {
	buildingIDs.CORE: BaseBuildingBuilder
		.new(preload("res://buildings/core/Core.tscn"), {})
		.withRecipes({ RecipeData.recipeID.NANITE_TO_SCRAP: true }, 1, 100)
		.build(),
	buildingIDs.EXTRACTOR: BaseBuildingBuilder
		.new(preload("res://buildings/extractor/Extractor.tscn"), { ResourceData.resourceID.NANITES: 10 })
		.build(),
	buildingIDs.ROUTER: BaseBuildingBuilder
		.new(preload("res://buildings/router/Router.tscn"), { ResourceData.resourceID.NANITES: 5 })
		.build(),
	buildingIDs.FOUNDRY: BaseBuildingBuilder
		.new(preload("res://buildings/foundry/Foundry.tscn"), { ResourceData.resourceID.NANITES: 25 })
		.withRecipes({
			RecipeData.recipeID.NANITE_TO_SCRAP: { 'research': ResearchData.researchIDs.FOUNDRY_NANITES },
			RecipeData.recipeID.SCRAP_TO_BASIC_PLATES: true,
			RecipeData.recipeID.BASIC_PLATES_TO_BASIC_CIRCUITS: { 'research': ResearchData.researchIDs.BASIC_CIRCUIT }
		}, 5, 5)
		.build(),
	buildingIDs.ANALYZER: BaseBuildingBuilder
		.new(preload("res://buildings/analyzer/Analyzer.tscn"),
			{ ResourceData.resourceID.NANITES: 25, ResourceData.resourceID.BASIC_PLATES: 5 })
		.build(),
	buildingIDs.RESEARCHER: BaseBuildingBuilder
		.new(preload("res://buildings/researcher/Researcher.tscn"),
			{ ResourceData.resourceID.NANITES: 25, ResourceData.resourceID.BASIC_PLATES: 5 })
		.build(),
	buildingIDs.BORE: BaseBuildingBuilder
		.new(preload("res://buildings/bore/Bore.tscn"),
			{ ResourceData.resourceID.SCRAP: 25, ResourceData.resourceID.BASIC_PLATES: 5 })
		.build()
}).call();
