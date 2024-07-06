extends AnimatedSprite2D
class_name Avatar

signal s_avatar_tapped

func _input(event):
	if event is InputEventMouseButton:
		if event.double_click:
			#if get_rect().has_point(to_local(event.position)):
			print("DOUBLE_CLICK_BBBBB")
			s_avatar_tapped.emit()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
