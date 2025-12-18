class_name mio
extends RefCounted


class Reconfig extends RefCounted:
	var flag_dated: bool = true
	func post() -> void: flag_dated = true
	func process() -> void:
		if flag_dated:
			_process()
			flag_dated = false
	func _process() -> void: pass

class Stat extends RefCounted:
	var stat_name: StringName
	var target: Variant
	var actual: Variant
	func _init(sn: StringName, t: Variant) -> void:
		stat_name = sn
		target = t
		actual = t

class SmoothVector2 extends  RefCounted:
	var target: Vector2 = Vector2.ZERO
	var actual: Vector2 = Vector2.ZERO
	var drag: float = 0.2
	var deadzone: float = 0.05
	func _init(t: Vector2 = Vector2.ZERO, a: Vector2 = Vector2.ZERO, d: float = 0.2, z: float = 0.05): 
		target = t
		actual = a 
		drag = d
		deadzone = z
	func process(delta: float) -> void: 
		actual = lerp(actual, target, delta / drag) if (actual - target).length() > deadzone else target

class SmoothVector3 extends RefCounted:
	var target: Vector3 = Vector3.ZERO
	var actual: Vector3 = Vector3.ZERO
	var drag: float = 0.2
	var deadzone: float = 0.05
	func _init(t: Vector3 = Vector3.ZERO, a: Vector3 = Vector3.ZERO, d: float = 0.2, z: float = 0.05): target = t; actual = a; drag = d; deadzone = z
	func process(delta: float) -> void: 
		actual = lerp(actual, target, delta / drag) if (actual - target).length() > deadzone else target

class SmoothFloat extends RefCounted:
	var target: float = 0.
	var actual: float = 0.
	var drag: float = 0.2
	var deadzone: float = 0.005
	func _init(t: float = 0., a: float = 0., d: float = 0.2, z: float = 0.05): target = t; actual = a; drag = d; deadzone = z
	func process(delta: float) -> void: actual = lerp(actual, target, delta / drag) if abs(actual - target) > deadzone else target


class SmoothStepFloat extends RefCounted:
	var start: float = 0.
	var target: float = 0.
	var actual: float = 0.
	var time: float = 0.5
	var deadzone: float = 0.005
	var progress = 0.
	func _init(t: float = 0., a: float = 0., ti: float = 0.5, z: float = 0.005): start = a; target = t; actual = a; time = ti; deadzone = z;
	func step(x: float) -> void:
		start = actual
		target = x
		progress = 0.
	func process(delta: float) -> void:
		if abs(target - actual) > deadzone:
			actual = lerp(start, target, smoothstep(0., time, progress))
			progress += delta
		else:
			if progress > 0.:
				actual = target
				progress = 0.

static func strike_tween(t: Tween) -> void: if t: if t.is_valid(): t.kill()
static func gx(n: Node3D) -> Vector3: return n.global_transform.basis.x
static func gy(n: Node3D) -> Vector3: return n.global_transform.basis.y
static func gz(n: Node3D) -> Vector3: return n.global_transform.basis.z

static func get_view_position(node: Node3D, view_res: Vector2 = Vector2.ZERO, camera: Camera3D = null) -> Vector2:
	if camera:
		if view_res.length() == 0.:		return camera.unproject_position(node.global_position)
		else:							return camera.unproject_position(node.global_position) / view_res * Vector2(DisplayServer.window_get_size())
	else:
		if view_res.length() == 0.:		return node.get_viewport().get_camera_3d().unproject_position(node.global_position)
		else:							return node.get_viewport().get_camera_3d().unproject_position(node.global_position) / view_res * Vector2(DisplayServer.window_get_size())
