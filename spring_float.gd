@icon("res://global/mio/img/img_Icon_SpringFloat.svg")
@tool
class_name SpringFloat
extends Node


const DAMP_TO_SPEED_RATIO		: float = 200.
const DAMP_SCALE						: float = 40.
const ELASTICITY_SCALE 			: float = 30.
const MASS_SCALE						: float = 5.
const TIMEOUT								: float = 1.



@export var target				: float = 0.
@export var actual				: float = 0.

@export var mass					: float = 1.
@export var elasticity		: float = 20.
@export var damp					: float = 10.
@export var deadzone			: float = 0.0001

@export_group("Snapped")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var flag_snapped: bool = false
@export var target_idx		: int = 0:
	set(v): 
		var idx = clampi(v, 0, snap_values.size() - 1)
		if flag_snapped and (not flag_smoothstep):
			target = snap_values[idx]
		elif flag_snapped and flag_smoothstep:
			s = 0.
			from = snap_values[target_idx]
			to = snap_values[idx]
			pass
		target_idx = idx
@export var snap_values		: Array[float] = [0., 1.]
@export_subgroup("Smoothstep")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var flag_smoothstep: bool = false
@export_range(0.05, 2.) var step_length: float = 0.25


var x	 : Vector2 = Vector2.ZERO
var dx : float = 0.

var s  		: float = 1.
var from 	: float = 0.
var to		: float = 0.

var velocity			: float = 0.
var reaction			: float = 0.
var timeout				: float = 0.

var flag_in_transit: bool = false
var flag_can_sleep: bool = false
var flag_sleeping: bool = false

func _physics_process(delta: float) -> void:

	flag_can_sleep = (abs(target - actual) < deadzone and abs(1. - s) < deadzone)
	timeout = clampf(timeout - delta, 0., TIMEOUT) if flag_can_sleep else TIMEOUT
	flag_sleeping = flag_can_sleep and timeout <= 0.

	if flag_sleeping: return

	if flag_smoothstep:
		s = move_toward(s, 1., delta / step_length)
		target = remap(smoothstep(0., 1., s), 0., 1., from, to)

	x.x = target - actual
	dx 	= x.x - x.y
	x.y = x.x

	reaction = dx * damp
	var force: float = elasticity * x.x * ELASTICITY_SCALE + reaction * DAMP_SCALE

	velocity += force / (mass * MASS_SCALE) if abs(force) >= deadzone else 0.
	actual += velocity * delta if abs(velocity) >= deadzone else 0.

