extends Spatial

export var flame_velocity = 10

func _process(delta):
	var flame_direction = Vector3()
	flame_direction.x = 1 #atan2(abs($"../../Player".linear_velocity.y), flame_velocity)  # y axis
	flame_direction.y = -atan2(-$"../../Player".linear_velocity.x, flame_velocity)	  # x axis
	flame_direction.z = -atan2(-$"../../Player".linear_velocity.z, flame_velocity)	  # z axis
	
	var flame_module = flame_velocity + flame_velocity * atan2(abs($"../../Player".linear_velocity.x), flame_velocity) - $"../../Player".linear_velocity.y

	$Flame.process_material.set("direction", flame_direction)
	$Flame.process_material.set("initial_velocity", flame_module)
	# print($Flame.process_material.get("direction"))
	# print("Fldir:" + str(flame_direction) + " Flmd " + str(flame_module))

	#$"../../Player".linear_velocity)
