extends Spatial

#onready var StartOffset = self.transform.origin - $"../Player".transform.origin
onready var StartOffset = self.transform.origin

func _process(delta):
	self.transform.origin = $"../Player".transform.origin + StartOffset
