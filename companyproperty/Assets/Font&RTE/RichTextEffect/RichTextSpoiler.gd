@tool
extends RichTextEffect
class_name RichTextSpoiler
var bbcode = "spoiler"

var time := 0.0
var visible := false
var last_glyph := [-1]
var index : int
func _process_custom_fx(char_fx: CharFXTransform):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("speed", 10)
	var span = char_fx.env.get("span", 8)
	
	time = char_fx.elapsed_time
	var time_int := int(time*5*speed)
	
	var temp := char_fx.glyph_index
	char_fx.glyph_index = (temp+randi()%11+1)/(randi()%3+1)
	char_fx.transform = char_fx.transform.translated_local(Vector2( randf_range(-4, 4),randf_range(-4, 4)))
	return true
