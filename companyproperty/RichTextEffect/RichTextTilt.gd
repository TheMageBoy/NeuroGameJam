@tool
extends RichTextEffect
class_name RichTextJumble
var bbcode = "jumble"

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
	
	# int div
	@warning_ignore("integer_division")
	index = (time_int/8)%span if last_glyph.size() > index else (index+1)%span
	
	if last_glyph.size() > index:
		print(char_fx.glyph_index, ": ", last_glyph[last_glyph.size()-1])
	var temp := char_fx.glyph_index
	if last_glyph.size() > index:
		char_fx.glyph_index = last_glyph[index]
	if temp != -1 and temp != last_glyph[-1]:
		print("Change")
		if last_glyph.size() > index:
			last_glyph.remove_at(0)
		last_glyph.append(temp)
	return true
