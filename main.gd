extends Node2D

class_name Main

var MenuItemConfigLeft = [
	{"icon" : "Favorites.png",
	"text" : "CGJ 2024"
	},
	{"icon" : "FolderOpened.png",
	"text" : "Limited and Limitless"
	},
	{"icon" : "Hearts.png",
	"text" : "Limitless NIC"
	},
	{"icon" : "Paint.png",
	"text" : "Alleycatneko"
	},
	{"icon" : "Paint.png",
	"text" : "Fandy"
	},
	{"icon" : "Paint.png",
	"text" : "orin"
	},
	{"icon" : "Programs.png",
	"text" : "Shane533"
	},
	{"icon" : "Arrow.png",
	"text" : "All Programs"
	},
]

var MenuItemConfigRight = [
	{"icon" : "MyComputer.png",
	"text" : "My Computer"
	},
	{"icon" : "MyDocuments.png",
	"text" : "My Documents"
	},
	{"icon" : "MyGames.png",
	"text" : "My Games"
	},
	{"icon" : "MyMusic.png",
	"text" : "My Music"
	},
	{"icon" : "MyNetworkPlaces.png",
	"text" : "My NetworkPlaces"
	},
	{"icon" : "MyPictures.png",
	"text" : "My Pictures"
	},
	{"icon" : "MyVideos.png",
	"text" : "My Videos"
	},
]

var MenuItemConfigSecond = [
	{"icon" : "StartMenuPrograms.png",
	"text" : "Games"
	},
	{"icon" : "MyDocuments.png",
	"text" : "My Documents"
	},
	{"icon" : "MyGames.png",
	"text" : "My Games"
	},
	{"icon" : "MyMusic.png",
	"text" : "My Music"
	},
	{"icon" : "MyNetworkPlaces.png",
	"text" : "My Network"
	},
	{"icon" : "MyPictures.png",
	"text" : "My Pictures"
	},
	{"icon" : "MyVideos.png",
	"text" : "My Videos"
	},
]

var MenuItemConfigGames = [
	{"icon" : "Minesweeper.png",
	"text" : "MineSweep"
	},
	#{"icon" : "Pinball.png",
	#"text" : "Pinball"
	#}
]

enum GameState { #every state is wait for input
	
	BEFORE_START,
	TRAPPED_IN_AVATAR,
	TWEEN_AFTER_TAP,
	HANG_IN_AVATAR,
	TWEEN_AFTER_SUBMIT,
	WAIT_FOR_SCROLL,
	TWEEN_AFTER_SCROLL,
	WAIT_FOR_START_MENU,
	TWEEN_JUMP_TO_START_MENU,
	WAIT_FOR_SUB_MENU,
	TWEEN_MOVE_TO_SUB_MENU,
	WAIT_FOR_GAMES_MENU,
	TWEEN_MOVE_TO_GAMES_MENU,
	WAIT_FOR_CLICK_MINESWEEP,
	TWEEN_JUMP_INTO_MINESWEEP,
	WAIT_FOR_MINESWEEP,
	TWEEN_EXPLODING,
	TWEEN_FLOATING_IN_VOID,
	GAME_OVER,
	NOT_OVER_YET,
}

#const START_W:int = 480
#const START_H:int = 400
const INIT_W:int = 72 * 1.7
const INIT_H:int = 72 * 1.7
const INIT_X:int = -2016
const INIT_Y:int = -379 
const WX_W:int = 960
const WX_H:int = 800
const WINDOWS_W:int = 1920
const WINDOWS_H:int = 1080
const WX_START_X:int = -1200
const WX_START_Y:int = -210
const FALL_HEIGHT:int = 250

const BOUNCE_TIMES:int = 7

@export var avatar: Avatar
@export var bottom: TextureRect
@export var content: Control
@export var newLineMine: Control
@export var newLineYours: Control
@export var wx_yundong: Control
@export var tap_label: Control
@export var input_text: LineEdit
@export var scroller: ScrollContainer
@export var start_menu: Control
@export var left_list: VBoxContainer
@export var right_list: VBoxContainer
@export var second_menu: Control
@export var games_menu: Control
@export var mine_sweep: MineSweep

var menu_item_ts = load("res://menu_item.tscn")

var _state: GameState
var _can_input: bool
var _focus_on_avatar_frame:bool = false

var _start_tap_count = 0
var _is_desktop_debug = false

func init():
	_state = GameState.BEFORE_START
	get_viewport().size = Vector2(INIT_W, INIT_H)
	get_window().size = Vector2(INIT_W, INIT_H)
	self.position = Vector2(INIT_X, INIT_Y)
	avatar.play("jump")
	
func init_wx():
	print("INIT_WX")
	#content.position = Vector2(0, 100)
	get_viewport().size = Vector2(WX_W, WX_H)
	get_window().size = Vector2(WX_W, WX_H)
	#get_tree().root.size.x = WX_W
	#get_tree().root.size.y = WX_H
	_state = GameState.TRAPPED_IN_AVATAR
	tap_label.visible = false
	$WX.visible = true
	#avatar.position.x = AVATAR_INIT_X
	#avatar.position.y = AVATAR_INIT_Y
	avatar.play("jump")
	newLineMine.visible = false
	newLineYours.visible = false
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(WX_START_X, WX_START_Y), 1)
	#tween.parallel().tween_property(get_viewport(), "size", Vector2(WX_W, WX_H), 1)
	#tween.parallel().tween_property(get_window(), "size", Vector2(WX_W, WX_H), 1)
	#self.position = 

func _on_avatar_tapped(is_double:bool):
	print("Avatar Tapped")
	if _state == GameState.TRAPPED_IN_AVATAR and is_double:
		next_state()
		
	if  _state == GameState.BEFORE_START:
		_start_tap_count += 1
		if _start_tap_count >= 3:
			next_state()

func avatar_shake():
	tap_label.visible = true
	avatar.rotation = 0.5
	avatar.play("tap")
	var tween = create_tween()
	tween.tween_property(avatar, "rotation", 0, 0.5).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_interval(0.5)
	#tween.tween_method(show_debug_text,)
	tween.tween_callback(drop_bottom)
	
func drop_bottom():
	avatar.stop()
	avatar.play("hang")
	print("DROP_BOTTOM")
	$WX/Control/Content/FirstLine/AvatarFrame/GlassBreak.play()
	var tween = create_tween()
	tween.tween_property(bottom, "position:y", bottom.position.y + 1000, 1).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(bottom, "rotation", 1, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(avatar, "position", Vector2(avatar.position.x - 18, avatar.position.y+35), 0.5).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(scale_to_wx)
	
func scale_to_wx():
	set_hang_anim()
	#scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
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
	tween.parallel().tween_property(self, "position", Vector2(-315,-120), 1)
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), 1)
	#tween.tween_property(vp, "position:x", 0, 1)
	tween.tween_callback(next_state)
	
func after_submit_text():
	if input_text.text != "":
		newLineMine.visible = true
		newLineMine.get_child(1).text = "锟斤拷烫烫烫"#input_text.text
		input_text.text = ""
		var tween = create_tween()
		tween.tween_property(content, "position:y", 50, 0.1)
		tween.tween_interval(1)
		tween.tween_property(content, "position:y", 0, 0.1)
		
		tween.tween_callback(jump_down)

func jump_down():
	newLineYours.visible = true
	$WX/Control/Content/NewLineYours/NewMessage.play()
	avatar.play("fall")
	var tween = create_tween()
	tween.tween_property(avatar, "position:y", avatar.position.y+FALL_HEIGHT, 0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(avatar_anim.bind("land"))
	tween.tween_interval(0.2)
	tween.tween_callback(finish_tween_submit)

func avatar_anim(ani):
	avatar.play(ani)
	
func finish_tween_submit():
	avatar.play("walk")
	var tween = create_tween()
	tween.tween_interval(0.2)
	tween.tween_property(avatar, "position:x", avatar.position.x-20, 0.5)
	tween.tween_property(avatar, "position:y", avatar.position.y+3, 0.5)
	tween.tween_property(avatar, "position:x", avatar.position.x-320, 2)
	tween.tween_property(avatar, "position:y", avatar.position.y+80, 0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(avatar, "position:x", avatar.position.x-660, 2)
	#tween.tween_property(avatar, "position:x", avatar.position.x-660, 0.2)
	tween.tween_callback(climb_to_left_list)
	#next_state()

func climb_to_left_list():
	avatar.get_parent().remove_child(avatar)
	wx_yundong.add_child(avatar)
	avatar.position = Vector2(100, -40)
	avatar.play("look_up")
	scroller.scroll_vertical = 100
	#scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	next_state()

func set_hang_anim():
	avatar.play("hang")
	input_text.grab_focus()
	
		
func next_state():
	print("Next State,pre %s" % GameState.keys()[_state])
	match _state:
		GameState.BEFORE_START:
			_state = GameState.TRAPPED_IN_AVATAR
			init_wx()
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
		GameState.TWEEN_AFTER_SUBMIT:
			_state = GameState.WAIT_FOR_SCROLL
			ready_for_input()
		GameState.WAIT_FOR_SCROLL:
			_state = GameState.TWEEN_AFTER_SCROLL
			scale_to_desktop()
		GameState.TWEEN_AFTER_SCROLL:
			_state = GameState.WAIT_FOR_START_MENU
			ready_for_input()
		GameState.WAIT_FOR_START_MENU:
			_state = GameState.TWEEN_JUMP_TO_START_MENU
			jump_to_start_menu()
		GameState.TWEEN_JUMP_TO_START_MENU:
			_state = GameState.WAIT_FOR_SUB_MENU
			ready_for_input()
		GameState.WAIT_FOR_SUB_MENU:
			_state = GameState.TWEEN_MOVE_TO_SUB_MENU
			move_to_sub_menu()
		GameState.TWEEN_MOVE_TO_SUB_MENU:
			_state = GameState.WAIT_FOR_GAMES_MENU
			ready_for_input()
		GameState.WAIT_FOR_GAMES_MENU:
			_state = GameState.TWEEN_MOVE_TO_GAMES_MENU
			move_to_games_menu()
		GameState.TWEEN_MOVE_TO_GAMES_MENU:
			_state = GameState.WAIT_FOR_CLICK_MINESWEEP
			ready_for_input()
		GameState.WAIT_FOR_CLICK_MINESWEEP:
			_state = GameState.TWEEN_JUMP_INTO_MINESWEEP
			jump_into_minesweep()
		GameState.TWEEN_JUMP_INTO_MINESWEEP:
			_state = GameState.WAIT_FOR_MINESWEEP
			ready_for_input()
		GameState.WAIT_FOR_MINESWEEP:
			_state = GameState.TWEEN_EXPLODING
			var tween = create_tween()
			tween.tween_property(mine_sweep, "modulate", Color.RED, 0.5)
			tween.tween_callback(explode)
		GameState.TWEEN_EXPLODING:
			_state = GameState.TWEEN_FLOATING_IN_VOID
			full_black()
		GameState.TWEEN_FLOATING_IN_VOID:
			_state = GameState.GAME_OVER
		GameState.GAME_OVER:
			_state = GameState.NOT_OVER_YET
			
			
	print("Now State %s" % GameState.keys()[_state])

func jump_to_start_menu():
	open_start_menu()
	$WX.visible = false
	$BottomWX.frame = 1
	avatar.play("fall")
	var tween = create_tween()
	tween.tween_property(avatar, "position:y", 382, 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(land_on_start_menu)
	
func move_to_sub_menu():
	avatar.scale.x = -avatar.scale.x
	avatar.play("walk")
	var tween = create_tween()
	tween.tween_property(avatar, "position:x", 445, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(stop_moving)
	
func stop_moving():
	avatar.play("look_down")
	next_state()
	
func move_to_games_menu():
	avatar.play("walk")
	var tween = create_tween()
	tween.tween_property(avatar, "position:x", 645, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(stop_moving)
	

func on_menu_hover(id: MenuItem.eMenuID):
	match id:
		MenuItem.eMenuID.ALL_PROGRAMS:
			show_all_programs_menu()
		MenuItem.eMenuID.GAMES:
			show_game_menu()

func show_all_programs_menu():
	if _state != GameState.WAIT_FOR_SUB_MENU:
		return
	second_menu.visible = true
	for child in second_menu.get_child(0).get_children():
		child.queue_free()
	for obj in MenuItemConfigSecond:
		var item = menu_item_ts.instantiate()
		var id = MenuItem.eMenuID.GAMES if obj.text == "Games" else MenuItem.eMenuID.NONE
		item.init(id, obj.icon, obj.text, false)
		#item.scale = Vector2(0.5, 0.5) 
		item.s_hover_menu_item.connect(on_menu_hover)
		#left_list.add_child(item)
		second_menu.get_child(0).add_child(item)
	next_state()
	
func show_game_menu():
	if _state != GameState.WAIT_FOR_GAMES_MENU:
		return
	for child in games_menu.get_child(0).get_children():
		child.queue_free()
	games_menu.visible = true
	for obj in MenuItemConfigGames:
		var item = menu_item_ts.instantiate()
		var id = MenuItem.eMenuID.MINE_SWEEP if obj.text == "MineSweep" else MenuItem.eMenuID.NONE
		item.init(id, obj.icon, obj.text, true)
		#item.scale = Vector2(0.5, 0.5) 
		item.s_hover_menu_item.connect(on_menu_hover)
		item.s_click_mine_sweep.connect(on_click_minesweep)
		#left_list.add_child(item)
		games_menu.get_child(0).add_child(item)
	next_state()

func on_click_minesweep():
	if _state == GameState.WAIT_FOR_CLICK_MINESWEEP:
		print("CLICK MINESWEEP")
		next_state()

func open_minesweep():
	mine_sweep.visible = true
	$BottomMS.visible = true
	mine_sweep.init()
	mine_sweep.s_explode.connect(_on_explode)
	
func _on_explode():
	next_state()
	
	
func jump_into_minesweep():
	open_minesweep()
	avatar.scale.x = -1 * avatar.scale.x
	avatar.play("normal_jump")
	var tween = create_tween()
	tween.tween_property(avatar, "position:x", 700, 1).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(avatar, "position:y", 340, 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(land_into_minesweep)

func land_into_minesweep():
	print("Land into minesweep")
	avatar.play("idle")
	avatar.get_parent().remove_child(avatar)
	mine_sweep.add_child(avatar)
	avatar.position = Vector2(80, 258)
	mine_sweep.start_game()
	#604,782;  670,75
	get_window().size = Vector2(604, 782)
	get_viewport().size = Vector2(604, 782)
	self.position = Vector2(-679, -75)
	next_state()

func open_start_menu():
	print("Start Start Menu")
	start_menu.visible = true
	second_menu.visible = false
	games_menu.visible = false
	var count = 0
	for obj in MenuItemConfigLeft:
		var item = menu_item_ts.instantiate()
		var id = MenuItem.eMenuID.ALL_PROGRAMS if obj.text == "All Programs" else MenuItem.eMenuID.NONE
		item.init(id, obj.icon, obj.text, true)
		item.s_hover_menu_item.connect(on_menu_hover)
		left_list.add_child(item)
		count = count + 1
		if count == 2 or count == 8:
			left_list.add_child(HSeparator.new())
	
	count = 0	
	for obj in MenuItemConfigRight:
		var item = menu_item_ts.instantiate()
		var id = MenuItem.eMenuID.ALL_PROGRAMS if obj.text == "All Programs" else MenuItem.eMenuID.NONE
		item.init(id, obj.icon, obj.text, true)
		right_list.add_child(item)
		count = count + 1
		if count == 3 or count == 6:
			right_list.add_child(HSeparator.new())

func land_on_start_menu():
	avatar.play("land")
	next_state()

func scale_to_desktop():
	#var world_p = avatar.to_global(avatar.position)
	start_menu.visible = false
	$BottomMS.visible = false
	wx_yundong.remove_child(avatar)
	self.add_child(avatar)
	#avatar.position = avatar.to_local(world_p)
	avatar.position = Vector2(547, 83)
	#avatar.position = Vector2(100, 100)
	avatar.play("idle")
	get_window().size = Vector2(1280, 960)
	var vp = get_viewport()
	var tween = create_tween()
	tween.tween_property(vp, "size", Vector2(1280, 960), 1)
	tween.parallel().tween_property(self, "position", Vector2(0,0), 1)
	tween.tween_callback(walk_to_start_menu)
	
func walk_to_start_menu():
	avatar.play("walk")
	var tween = create_tween()
	tween.tween_property(avatar, "position:x", 310, 1)
	tween.tween_callback(stop_over_edge)
	
func stop_over_edge():
	avatar.play("look_down")
	next_state()

func ready_for_input():
	_can_input = true

func disable_input():
	_can_input = false	

func _input(event):
	#print("Scroll %d" % $Control/ScrollContainer.scroll_vertical)
	var vp:Viewport = get_tree().root
	if event is InputEventKey:
		if event.is_pressed():
			match event.keycode:
				KEY_LEFT:
					create_tween().tween_property(vp, "position:x", 0, 0.5).set_trans(Tween.TRANS_SPRING)
				KEY_RIGHT:
					create_tween().tween_property(vp, "position:x", DisplayServer.screen_get_size().x - get_window().size.x, 0.5).set_trans(Tween.TRANS_SPRING)
				KEY_UP:
					create_tween().tween_property(vp, "position:y", 0, 0.5).set_trans(Tween.TRANS_SPRING)
				KEY_DOWN:
					create_tween().tween_property(vp, "position:y", DisplayServer.screen_get_size().y - get_window().size.y, 0.5).set_trans(Tween.TRANS_SPRING)
				KEY_ENTER:
					pass
					#explode()
				KEY_W:
					debug()
	elif event is InputEventMouseButton:
		if event.is_pressed():
			$ClickSFX.play()
			if event.is_pressed() and _focus_on_avatar_frame:
				_on_avatar_tapped(event.double_click)
					

func debug():
	save_poster()
	print(OS.get_executable_path())
	
func save_poster():
	var tex:Texture2D = load("res://Res/poster.png")
	tex.get_image().save_png("user://FrameBreaker.png")
					
func explode():
	
	var direction = [1,3,7,9].pick_random()
	#direction = 3

	tween_explode(direction, BOUNCE_TIMES)

func tween_explode(direction, bounce_times):
	print("Explode to position %d" % direction)
	var vp = get_tree().root
	var sz = DisplayServer.screen_get_size()
	var wz = get_window().size
	var target_pos
	var next_dir
	match direction:
		1:
			var top = vp.position.y
			var left = vp.position.x
			var dis = top if top < left else left
			next_dir = 7 if top < left else  3
			print("top %d, left %d" % [top, left])
			target_pos = Vector2(vp.position.x-dis, vp.position.y-dis)
		3:
			var top = vp.position.y
			var left = sz.x - wz.x - vp.position.x
			var dis = top if top < left else left
			next_dir = 9 if top < left else  1
			print("top %d, left %d" % [top, left])
			target_pos = Vector2(vp.position.x+dis, vp.position.y-dis)
		7:
			var top = sz.y - wz.y - vp.position.y
			var left = vp.position.x
			var dis = top if top < left else left
			next_dir = 1 if top < left else  9
			print("top %d, left %d" % [top, left])
			target_pos = Vector2(vp.position.x-dis, vp.position.y+dis)
			
		9:
			var top = sz.y - wz.y - vp.position.y
			var left = sz.x - wz.x - vp.position.x
			var dis = top if top < left else left
			next_dir = 3 if top < left else  7
			print("top %d, left %d" % [top, left])
			target_pos = Vector2(vp.position.x+dis, vp.position.y+dis)
			
	var tween = create_tween()
	print("Moveto %d,%d" % [target_pos.x, target_pos.y])
	var time = 0.05 + 0.02 * (BOUNCE_TIMES - bounce_times)
	tween.tween_property(vp, "position:x", target_pos.x, time).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(vp, "position:y", target_pos.y, time).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(bounce.bind(next_dir, bounce_times))
			
func bounce(direction, times):
	if times == 0:
		if _state == GameState.TWEEN_EXPLODING:
			finish_explode()
		return
	times = times - 1
	tween_explode(direction, times)
	print("XXX")
	
func finish_explode():
	get_viewport().position = Vector2(DisplayServer.screen_get_size().x/2 - get_viewport().size.x/2, DisplayServer.screen_get_size().y/2 - get_viewport().size.y/2)
	var tween = create_tween()
	tween.tween_property(mine_sweep, "modulate", Color.BLACK, 1)
	tween.tween_callback(next_state)
	
func full_black():
	#var w_pos = mine_sweep.to_global(avatar.position)
	mine_sweep.remove_child(avatar)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get_viewport().size = get_window().size
	mine_sweep.scale = Vector2(100,100)
	self.add_child(avatar)
	avatar.position = self.to_local(get_window().size/2)
	avatar.scale = Vector2(5,5)
	var tween = create_tween()
	tween.tween_property(avatar, "scale", Vector2(0,0), 7)
	tween.tween_interval(1)
	tween.tween_callback(end_game)

func end_game():
	next_state()
	var label_ts = load("res://game_over.tscn")
	var go_label = label_ts.instantiate()
	self.add_child(go_label)
	go_label.scale = Vector2(3, 3)
	go_label.position = self.to_local(get_window().size/3)
	save_poster()
	var tn = create_tween()
	tn.tween_interval(1)
	tn.tween_property(go_label, "text", "See you in your %HOME%!", 1)
	tn.tween_interval(3)
	tn.tween_callback(quit)
	
	
func quit():
	get_tree().quit()	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	#debug_desktop()
	pass # Replace with function body.

func debug_desktop():
	mine_sweep.visible = false
	start_menu.visible = false
	second_menu.visible = false
	games_menu.visible = false
	_state = GameState.WAIT_FOR_START_MENU
	_is_desktop_debug = true
	avatar.get_parent().remove_child(avatar)
	get_window().size = Vector2(1280, 960)
	get_viewport().size = Vector2(1280, 960)
	self.scale = Vector2(1, 1)
	self.position = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match _state:
		GameState.WAIT_FOR_SCROLL:
			if scroller.scroll_vertical > 700:
				print("CLIMB TO WX TOP")
				next_state()
		GameState.TWEEN_FLOATING_IN_VOID:
			avatar.rotation = avatar.rotation + 0.01
	#if _state == GameState.WAIT_FOR_SCROLL:
		#var value = $Control/ScrollContainer.scroll_vertical
		#avatar.position.y = 10 + value
	pass

func _on_avatar_animation_finished():
	if avatar.animation == "land":
		avatar.play("look_down")
	if avatar.animation == "look_up":
		avatar.play("idle")
	if avatar.animation == 'look_down':
		avatar.play("idle")
	if _state == GameState.TRAPPED_IN_AVATAR:
		var key = ["jump", "idle"].pick_random()
		avatar.play(key)
	elif _state == GameState.BEFORE_START:
		avatar.play("jump")
	elif _state == GameState.WAIT_FOR_MINESWEEP:
		var key = ["idle", "idle2", "idle3"].pick_random()
		avatar.play(key)

# Submit
func _on_button_pressed():
	print("Button Pressed")
	if _state != GameState.HANG_IN_AVATAR or input_text.text == "":
		return
	next_state()
	pass # Replace with function body.


func _on_texture_button_pressed():
	print("start button clicked")
	if _state != GameState.WAIT_FOR_START_MENU and not _is_desktop_debug:
		return
	next_state()
	pass # Replace with function body.


func _on_avatar_frame_mouse_entered():
	_focus_on_avatar_frame = true
	pass # Replace with function body.


func _on_avatar_frame_mouse_exited():
	_focus_on_avatar_frame = false
	pass # Replace with function body.


func _on_text_edit_text_submitted(new_text):
	_on_button_pressed()
	pass # Replace with function body.
