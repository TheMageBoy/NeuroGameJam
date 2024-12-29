@tool
extends RichTextEffect
class_name RichTextJoker
var bbcode = "joker"

var time := 0.0 
var offset_vector : Vector2
func _process_custom_fx(char_fx: CharFXTransform):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("speed", 10)
	var strength = char_fx.env.get("strength", 4)
	var span = char_fx.env.get("span", 21)
	
	time = char_fx.elapsed_time
	var time_int := int(time*5*speed)
	
	var colour_array := [Color.SEA_GREEN, Color.WEB_PURPLE, Color.SEA_GREEN, Color.DARK_GREEN, Color.WEB_PURPLE]
	char_fx.color = colour_array[(time_int/(100/speed)+char_fx.relative_index+char_fx.glyph_index)%colour_array.size()]
	
	#char_fx.transform = Transform2D(0, char_fx.transform.get_origin()).rotated_local((sin(time*speed+char_fx.relative_index/span))*strength/10)
	
	if randi() % 666:
		char_fx.transform =\
		char_fx.transform.translated_local( Vector2( (cos(time* ( (speed+char_fx.glyph_index%(span*3)-((span*3)/2))+((speed+char_fx.relative_index%span-(span/2)*2) )) ))*strength/8\
													,(sin(time* ( (speed+char_fx.glyph_index%(span*3)-((span*3)/2))+((speed+char_fx.relative_index%span-(span/2)/2) )) ))*strength/4))
	else:
		offset_vector = Vector2( cos(randi()%(span*3)-((span*3)/2))*strength/4, sin(randi()%(span*3)-((span*3)/2))*strength/4)
	char_fx.transform = char_fx.transform.translated_local(offset_vector)
	
	return true
