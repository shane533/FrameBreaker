extends Sprite2D
class_name MineSweep

signal s_explode

var minefield = [
	[0, 1, 1, 1, 1, 1],
	[0, 2, -1, 2, 1, -1],
	[2, 5, -1, 4, 2, 2],
	[-1, -1, -1, 3, -1, 2],
	[-1, 4, 3, 3, 3, -1],
	[-1, 1, 1, -1, 2, 1],
]
var _grids = [
	[],
	[],
	[],
	[],
	[],
	[]
]

@export var mine_count: Label
@export var time_count: Label

var _total_mine = 0
var _total_time = 0
var _is_start: bool = false
var grid_ts = load("res://grid.tscn")

func init():
	_total_mine = 0
	for i in range(6):
		for j in range(6):
			var value = minefield[i][j]
			if value < 0:
				_total_mine = _total_mine + 1
			var pos = Vector2(82+i*88, 260+j*88)
			var grid = grid_ts.instantiate()
			grid.position = pos
			grid.init(value < 0, value)
			grid.s_open_field.connect(_on_open_field)
			grid.s_flag_mine.connect(_on_flag_mine)
			_grids[i].append(grid)
			add_child(grid)
	print()
	
func start_game():
	print("START_GAME")
	_is_start = true
	tween_time()
	for i in range(3):
		for j in range(2):
			_grids[i][j].open_field()
	
func tween_time():
	if _is_start:
		var tween = create_tween()
		tween.tween_interval(1)
		tween.tween_callback(update_time)
	
func update_time():
	_total_time += 1
	time_count.text = "%d" % _total_time
	tween_time()

func _on_open_field(is_mine: bool):
	print("Open Field")
	if is_mine:
		explode()
	
func _on_flag_mine():
	print("flag mine")
	_total_mine -= 1
	update_display()

func update_display():
	mine_count.text = "%d" % _total_mine
	
func explode():
	_is_start = false
	s_explode.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
