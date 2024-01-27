extends Control

@export var dialog:Array

var current_dialog_id = 0
var in_use: bool = false
var tweening: bool = false
var tween:Tween

var signal_back = null

func _ready():
	visible = false

#dialogo con nombre
func init(passname:String,nameless:bool,passdialog:Array,end_of_dialog):
	if in_use:
		return
	signal_back = end_of_dialog
	#Utils.get_player().input = false
	in_use = true
	if !nameless:
		$Box2/Name.text = passname
		$Box2/Name.visible = !nameless
	dialog = passdialog
	
	current_dialog_id = -1
	next_line()
	visible = true

func _input(event):
	if not in_use:
		return
	if event.is_action_pressed("ACCEPT"):
		if !tweening:
			next_line()
		else:
			tween.kill()
			tween.emit_signal("finished")
			$Box2/Text.visible_ratio = 1
			tweening = false

func next_line():
	current_dialog_id += 1
	if current_dialog_id >= dialog.size():
		$Timer.start()
		visible = false 
		#Utils.get_player().input = true
		if signal_back != null:
			signal_back.emit()
		return
	else:
		$Box2/Text.visible_ratio = 0
		$Box2/Text.text = dialog[current_dialog_id]
		tweening = true
		tween = get_tree().create_tween()
		tween.tween_property($Box2/Text,"visible_ratio", 1, $Box2/Text.get_total_character_count()/12)
		await tween.finished
		tweening = false

func _on_timer_timeout():
	in_use = false
