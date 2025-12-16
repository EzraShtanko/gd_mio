@icon("uid://w30nh5l3gsq3")
@tool
class_name CustomConsolePrinter
extends Resource


@export var prefix: 	String 	= ""
@export var title:		String 	= "Untitled"
@export var suffix:		String 	= ""
@export var padding: 	int 	= 16
@export_enum(
	"light_gray",	"red",		"orange",		"yellow",		"lime",
	"cyan",			"turquoise",	"crimson",		"gold",			"salmon",
	"green",		"pink",			"violet",		"silver",		"white"
) var color:		String  = "lightgray"
@export var flag_bold:	bool 			= false

@export_tool_button("Print Test Message", "Node") var run_print_test_message: Callable = func () :
	log_oh("test message")
	log_ok("test message")
	log_ew("test message")
	log_fu("test message")

func headline() -> String:
	var h: String = "[b]%s[/b]" % title if flag_bold else "%s" % title

	h = "[color=gray]%s[/color][color=%s]%s[/color][color=gray]%s[/color]" % [prefix, color, h, suffix]
	h = h.rpad(clamp(padding - 3, 0, 256))
	return "%s : " % h

func log_ok(line: String) -> void:		print_rich("%s[color=lime]-V- %s[/color]" 			% [headline(), line])
func log_oh(line: String) -> void:		print_rich("%s[color=light_gray]-i- %s[/color]" 	% [headline(), line])
func log_ew(line: String) -> void:		print_rich("%s[color=orange]<!> %s[/color]" 		% [headline(), line])
func log_fu(line: String) -> void:		print_rich("%s[color=crimson]=X= %s[/color]"		% [headline(), line])
