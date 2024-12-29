extends Button

@onready var rts: RichTextLabel = $RichTextLabel
@onready var icon_sprite: Sprite2D = $Icon

const EMPTY_BOX = preload("res://Assets/UI/EmptyBox.tres")
const FILE_HOVER_BOX = preload("res://Assets/UI/FileHoverBox.tres")
var content : PackedScene
# Called when the node enters the scene tree for the first time.
