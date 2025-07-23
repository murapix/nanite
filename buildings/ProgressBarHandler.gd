@tool class_name ProgressBarHandler extends TextureProgressBar

@export_range(0,1,0.01) var fillBarStart: float;
@export_range(0,1,0.01) var fillBarEnd: float;

func setFillFromResources(
	resources: Dictionary[ResourceData.resourceID, float],
	limits: Dictionary[ResourceData.resourceID, int],
	invert = false
):
	setFillPercentage(
		Utils.sum(resources.values()) / max(1, Utils.sum(limits.values())),
		invert
	);

func setFillPercentage(percentage: float, invert: bool = false):
	if invert:
		percentage = 1 - percentage;
	self.value = fillBarStart + clamp(percentage, 0, 1) * (fillBarEnd - fillBarStart);
