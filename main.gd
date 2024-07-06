extends Node2D

class_name Main

enum GameState { #every state is wait for input
	
	BEFORE_START,
	TRAPPED_IN_AVATAR,
	TWEEN_AFTER_TAP,
	HANG_IN_AVATAR,
	TWEEN_AFTER_SUBMIT,
	WAIT_FOR_SCROLL,
	AFTER_SCROLL
}

#const START_W:int = 480
#const START_H:int = 400
const WX_W:int = 960
const WX_H:int = 800
const WINDOWS_W:int = 1920
const WINDOWS_H:int = 1080
const AVATAR_INIT_X:int = 35
const AVATAR_INIT_Y:int = 40
const FALL_HEIGHT:int = 260

@export var avatar: Avatar
@export var bottom: TextureRect
@export var content: Control
@export var newLineMine: Control
@export var newLineYours: Control

var _state: GameState
var _can_input: bool

func init():
	get_tree().root.size.x = WX_W
	get_tree().root.size.y = WX_H
	_state = GameState.TRAPPED_IN_AVATAR
	$Control/Content/TapLabel.visible = false
	avatar.s_avatar_tapped.connect(_on_avatar_tapped)
	avatar.position.x = AVATAR_INIT_X
	avatar.position.y = AVATAR_INIT_Y
	avatar.stop()
	newLineMine.visible = false
	newLineYours.visible = false
	content.position = Vector2(0, 100)

func _on_avatar_tapped():
	print("Avatar Tapped")
	if _state == GameState.TRAPPED_IN_AVATAR:
		next_state()

func avatar_shake():
	$Control/Content/TapLabel.visible = true
	avatar.rotation = 5
	var tween = create_tween()
	tween.tween_property(avatar, "rotation", 0, 0.5).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_interval(0.5)
	#tween.tween_method(show_debug_text,)
	tween.tween_callback(drop_bottom)
	
func drop_bottom():
	var tween = create_tween()
	tween.tween_property(bottom, "position:y", bottom.position.y + 1000, 1).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(bottom, "rotation", 1, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(avatar, "position", Vector2(avatar.position.x - 20, avatar.position.y+35), 0.5).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(scale_to_wx)
	
func scale_to_wx():
	set_hang_anim()
	var tween = create_tween()
	#var vp:Viewport = get_tree().root
	#get_window().size = Vector2(WX_W,WX_H)
	#vp.size = Vector2(WX_W, WX_H)
	#self.position.x = 0
	#next_state()
	##var wnd = get_window()
	#tween.tween_property(self, "scale", Vector2(1,1), 1)
	#tween.tween_property(vp, "size", Vector2(WX_W, WX_H), 1)
	#tween.parallel().tween_property(wnd, "size", Vector2(WX_W, WX_H), 1 )
	tween.parallel().tween_property(self, "position:x", 0, 1)
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), 1)
	#tween.tween_property(vp, "position:x", 0, 1)
	tween.tween_callback(next_state)
	
func after_submit_text():
	if $Control/TextEdit.text != "":
		newLineMine.visible = true
		$Control/Content/NewLineMine/Label.text = $Control/TextEdit.text
		$Control/TextEdit.text = ""
		var tween = create_tween()
		tween.tween_property(content, "position:y", 50, 0.1)
		tween.tween_interval(1)
		tween.tween_property(content, "position:y", 0, 0.1)
		
		tween.tween_callback(jump_down)

func jump_down():
	newLineYours.visible = true
	var tween = create_tween()
	tween.tween_property(avatar, "position:y", avatar.position.y+FALL_HEIGHT, 0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(finish_tween_submit)
	
func finish_tween_submit():
	avatar.play("walk")
	var tween = create_tween()
	tween.tween_property(avatar, "position:x", avatar.position.x-20, 0.5)
	tween.tween_property(avatar, "position:y", avatar.position.y+5, 0.5)
	tween.tween_property(avatar, "position:x", avatar.position.x-320, 3)
	tween.tween_property(avatar, "position:y", avatar.position.y+70, 0.5)
	tween.tween_property(avatar, "position:x", avatar.position.x-560, 3)
	tween.tween_property(avatar, "position:x", avatar.position.x-660, 0.2)
	tween.tween_callback(next_state)
	#next_state()

func set_hang_anim():
	avatar.play("hang")
	$Control/TextEdit.grab_focus()
	
		
func next_state():
	print("Next State,current %d" % _state)
	match _state:
		GameState.TRAPPED_IN_AVATAR:
			_state = GameState.TWEEN_AFTER_TAP
			disable_input()
			avatar_shake()
		GameState.TWEEN_AFTER_TAP:
			_state = GameState.HANG_IN_AVATAR
			set_hang_anim()
			ready_for_input()
		GameState.HANG_IN_AVATAR:
			_state = GameState.TWEEN_AFTER_SUBMIT
			after_submit_text()
			
func ready_for_input():
	_can_input = true

func disable_input():
	_can_input = false	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_set():
	if _state != GameState.HANG_IN_AVATAR:
		return
	next_state()
	
	pass # Replace with function body.


func _on_button_2_pressed():
	init()
	pass # Replace with function body.


func _on_text_edit_text_submitted(new_text):
	pass # Replace with function body.
