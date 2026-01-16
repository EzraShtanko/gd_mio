@icon("res://global/mio/img/img_Icon_CustomConsolePrinter_32x32px.png")
@tool
class_name CustomConsolePrinter
extends Resource


@export var prefix: 	String 	= ""
@export var title:		String 	= "Untitled"
@export var suffix:		String 	= ""
@export var padding: 	int 	= 16
@export_enum(
	"light_gray",	"red",			"orange",		"yellow",		"lime",
	"cyan",			"turquoise",		"crimson",		"gold",			"salmon",
	"green",			"pink",			"violet",		"silver",		"white"
) var color		: String  = "lightgray"
@export var flag_bold:	bool 			= false

@export var stash_log_size		: int		= 16

@export_tool_button("Print Test Message", "Node") var run_print_test_message: Callable = func () :
	log_oh("test message")
	log_ok("test message")
	log_ew("test message")
	log_fu("test message")

var stash_log: Array[String] = []


func headline() -> String:
	var h: String = "[b]%s[/b]" % title if flag_bold else "%s" % title

	h = "[color=gray]%s[/color][color=%s]%s[/color][color=gray]%s[/color]" % [prefix, color, h, suffix]
	h = h.rpad(clamp(padding - 3, 0, 256))
	return "%s : " % h

func log_ok(line: String, stash: bool = false) -> void:		print_rich("%s[color=lime]-V- %s[/color]" 		% [headline(), line]);	if stash: log_stash(line)
func log_oh(line: String, stash: bool = false) -> void:		print_rich("%s[color=light_gray]-i- %s[/color]" 	% [headline(), line]);	if stash: log_stash(line)
func log_ew(line: String, stash: bool = false) -> void:		print_rich("%s[color=orange]<!> %s[/color]" 		% [headline(), line]);	if stash: log_stash(line)
func log_fu(line: String, stash: bool = false) -> void:		print_rich("%s[color=crimson]=X= %s[/color]"		% [headline(), line]);	if stash: log_stash(line)

func log_stash(line: String) -> void:
	stash_log.push_front(line)
	while stash_log.size() > stash_log_size:	stash_log.pop_back()
