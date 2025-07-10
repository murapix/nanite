extends Control

@export var buildingID: BuildingData.buildingIDs:
	set(value):
		buildingID = value;
		var viewport = find_child('SubViewport');
		viewport.remove_child(viewport.get_child(0));
		viewport.add_child(BuildingData.buildings[buildingID].instantiate())
