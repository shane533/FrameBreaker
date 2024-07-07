extends Node2D

signal s_open_field(is_explode)
signal s_flag_mine(is_flag)

var _is_mine: bool
var _num: int
var _is_flaged: bool = false
var _is_opened:bool = false

@export var flag: Sprite2D
@export var label: AnimatedSprite2D
@export var open: Sprite2D
@export var mine: Sprite2D

func init(is_mine, num):
	_is_mine = is_mine
	_is_flaged = false
	_is_opened = false
	_num = num
	update_display()

func open_field():
	_is_opened = true
	update_display()
	s_open_field.emit(_is_mine)

func flag_mine():
	if _is_opened:
		return
	_is_flaged = not _is_flaged
	update_display()
	s_flag_mine.emit(_is_flaged)
	
func update_display():
	flag.visible = _is_flaged
	open.visible = not _is_opened
	mine.visible = _is_opened and _is_mine
	label.visible = _is_opened and _num > 0 and not _is_mine
	label.frame = _num - 1

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if open.get_rect().has_point(open.to_local(event.global_position)):
				if event.button_index == MOUSE_BUTTON_LEFT:
					open_field()
				elif event.button_index == MOUSE_BUTTON_RIGHT:
					flag_mine()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
