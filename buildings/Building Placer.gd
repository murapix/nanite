@tool class_name BuildingPlacer extends Control

@export var building: Building:
	set(value):
		building = value;
		value.position = Vector2(54, 65);
		value.scale = Vector2(0.25, 0.25);
		value.functional = false;
@export var buildingName: StringName:
	set(value):
		buildingName = value;
		var label: Label = get_node('HSplitContainer/VBoxContainer/Building Name');
		label.text = value;
@export var buildingDescription: StringName:
	set(value):
		buildingDescription = value;
		var label: Label = get_node("HSplitContainer/VBoxContainer/Building Description");
		label.text = value;
