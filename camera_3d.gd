extends Camera3D


const RAY_LENGTH = 1000.0

func get_mouse_pos():
	var camera3d = self
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera3d.project_ray_origin(mouse_pos)
	var to = from + camera3d.project_ray_normal(mouse_pos) * RAY_LENGTH
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result.is_empty() :return
	return raycast_result["position"]
