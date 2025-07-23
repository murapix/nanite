class_name Utils

static func sum(values: Array):
	return values.reduce(func(current, val) -> float: return current+val, 0.0);
