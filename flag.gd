class_name Flag
extends RefCounted

var x: int = 0x00
func reset() -> void: x = 0x00
func hint(f: int) -> bool: return f & x
func post(f: int) -> void: x |= f
func drop(f: int) -> void: x &= ~ f