extends Control

class_name MenuItem

enum eMenuID {
	NONE,
	ALL_PROGRAMS,
	GAMES,
	MINE_SWEEP
}

signal s_hover_menu_item(id: eMenuID)
signal s_click_mine_sweep

@export var highlight: TextureRect
@export var icon: TextureRect
@export var label: Label

var _id: eMenuID 
var _is_sub: bool

func init(id, url, dname, is_sub):
	_id = id
	_is_sub = is_sub
	highlight.visible = false
	highlight.texture = load("res://Res/UI/menu/blue_2.png") if is_sub else load("res://Res/UI/menu/blue_1.png")
	var png = "res://Res/Icon/menu_icon/%s" % url 
	icon.texture = load(png)
	label.text = dname
	label.label_settings = label.label_settings.duplicate()
	if id == eMenuID.ALL_PROGRAMS:
		icon.position = Vector2(140, 12)
		icon.scale = icon.scale * 0.5
		label.position.x = 40
		

func update_state(is_highlight:bool):
	highlight.visible = is_highlight
	if is_highlight:
		label.label_settings.font_color = Color.WHITE
		#set("theme_override_colors/font_color", Color.WHITE)
		
	else:
		label.label_settings.font_color = Color.BLACK
		#set("theme_override_colors/font_color", Color.BLACK)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if _id == eMenuID.MINE_SWEEP:
			s_click_mine_sweep.emit()

func _on_mouse_entered():
	s_hover_menu_item.emit(_id)
	update_state(true)
	
	pass # Replace with function body.


func _on_mouse_exited():
	update_state(false)
	pass # Replace with function body.
