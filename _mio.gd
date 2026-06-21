class_name mio
extends RefCounted


class Reconfig extends RefCounted:
	var flag_dated: bool = true
	var flags: Flag = Flag.new()
	func post(x: int = 0x00) -> void: flag_dated = true; flags.post(x)
	func process() -> void:
		if flag_dated:
			_process()
			flag_dated = false
			flags.reset()
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
		actual = lerp(actual, target, delta / (drag if drag > 0. else 1.)) if (actual - target).length() > deadzone else target

class SmoothVector3 extends RefCounted:
	var target: Vector3 = Vector3.ZERO
	var actual: Vector3 = Vector3.ZERO
	var drag: float = 0.2
	var deadzone: float = 0.05
	func _init(t: Vector3 = Vector3.ZERO, a: Vector3 = Vector3.ZERO, d: float = 0.2, z: float = 0.05): target = t; actual = a; drag = d; deadzone = z
	func process(delta: float) -> void: 
		actual = lerp(actual, target, delta / (drag if drag > 0. else 1.)) if (actual - target).length() > deadzone else target

class SmoothFloat extends RefCounted:
	var target: float = 0.
	var actual: float = 0.
	var drag: float = 0.2
	var deadzone: float = 0.005
	func _init(t: float = 0., a: float = 0., d: float = 0.2, z: float = 0.05): target = t; actual = a; drag = d; deadzone = z
	func process(delta: float) -> void: actual = lerp(actual, target, delta / (drag if drag > 0. else 1.)) if abs(actual - target) > deadzone else target


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

#class SmoothStepVector3 extends RefCounted:
	#var start		: Vector3 = 0.
	#var target		: 

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



static func grid_from_vec3(p: Vector3) -> Vector2i:
	var r = Plane(Vector3.UP).project(p)
	r.x = floor(r.x)
	r.z = floor(r.z)
	return Vector2i(r.x, r.z)


static func grid_diagonal_distance(p0: Vector2, p1: Vector2) -> float:
	var dx: float = p1.x - p0.x
	var dy: float = p1.y - p0.y
	return absf(max(absf(dx), absf(dy)))

static func grid_line(p0: Vector2, p1: Vector2) -> Array:
	var points: Array[Vector2i] = []
	var N = grid_diagonal_distance(p0, p1)
	for i in N:
		var t = 0. if N == 0 else i / N
		points.push_back(round(lerp(p0, p1, t)))
	return points

static func combine(a: Array, b: Array) -> Array:
	var c := a.duplicate()
	for i in b:
		if not i in c:
			c.push_back(i)
	return c


class MicroMachine extends RefCounted:
	var owner		: Node
	var current		: MicroState
	var initial		: MicroState
	func _init(n: Node) -> void: owner = n
	
	func switch_to(x: MicroState, params: Dictionary = {}) -> void:
		if current:		current.release(params)
		current = x
		current.assume(params)
	func process() -> void: if current: current._process()


class MicroState extends RefCounted:
	var machine		: MicroMachine
	var buffer		: Dictionary = {}
	var active		: bool = false
	func _init(m: MicroMachine) -> void: 				machine = m
	func overtake(params: Dictionary = {}) -> void:		machine.switch_to(self, params)
	func assume(params: Dictionary = {}) -> void:		_assume(params); active = true
	func _assume(_params: Dictionary = {}) -> void:		pass
	func process() -> void:								if active: _process()
	func _process() -> void:							pass
	func release(params: Dictionary = {}) -> void:		active = false; _release(params)
	func _release(_params: Dictionary = {}) -> void:	pass
