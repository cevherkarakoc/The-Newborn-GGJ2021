extends Area2D


enum {STATE_IDLE, STATE_MOVING, STATE_END}
enum LAYER {WALL = 1, CARRYABLE = 2, WATER = 4, TREE = 8, ROCK = 16, HOLE = 32}
enum TYPE {WOOD = 1024, PICKAXE = 2048, STONE = 4096}

onready var n_Cursor = $Cursor
onready var n_Dialog = $Dialog
onready var n_TweenMovement = $TweenMovement
onready var n_SFXPlayerSelect = $SFXPlayerSelect
var n_Lost = null

onready var m_focus = null
onready var m_carry = null

var m_state = STATE_IDLE

func _ready():
	n_Lost = get_parent().get_node("Lost")

func _input(event):
	if m_state != STATE_END and event.is_action_pressed("action") and m_focus:
		match m_focus.collision_layer:
			LAYER.CARRYABLE:
				if m_carry == m_focus:
					if m_carry.has_method("dropped"):
						m_carry.dropped()
					m_carry = null
					n_Cursor.set_text("Carry")
				else:
					if m_carry and m_carry.has_method("dropped"):
						m_carry.dropped()
					m_carry = m_focus
					if m_carry.has_method("hold"):
						m_carry.hold()
					n_Cursor.set_text("Drop")
			LAYER.WATER:
				if m_carry and m_carry.collision_mask == TYPE.WOOD :
					m_focus.bridge()
					m_carry.queue_free()
					m_carry = null
					clear_focus()
				else:
					n_Dialog.speak("I need some woods!")
			LAYER.TREE:
					m_focus.cut_down()
					clear_focus()
			LAYER.ROCK:
				if m_carry and m_carry.collision_mask == TYPE.PICKAXE :
					m_focus.breake()
					m_carry.queue_free()
					m_carry = null
					clear_focus()
				else:
					n_Dialog.speak("I need a pickaxe!")
			LAYER.HOLE:
				if m_carry and m_carry.collision_mask == TYPE.STONE :
						m_focus.fill()
						m_carry.queue_free()
						m_carry = null
						clear_focus()
				else:
					n_Dialog.speak("I need some stones!")


func _physics_process(delta):
	if m_state == STATE_IDLE:
		var rl = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		var ud = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		if rl or ud:
			if rl:
				ud = 0
			move(Vector2(rl * 16, ud * 16))


func move(direction):
	var target_position = position + direction
	var c = get_world_2d().direct_space_state.intersect_point(target_position, 1, [], 63 , false, true)
	var last_focus = m_focus
	
	n_Cursor.visible = false
	m_focus = null
	
	if len(c) == 0:
		if abs(n_Lost.position.y - target_position.y) > 16*11 or abs(n_Lost.position.x - target_position.x) > 16*11:
			n_Dialog.speak("I have to keep it in my sight!")
		else:
			m_state = STATE_MOVING
			
			n_TweenMovement.interpolate_property(
			self,"position",
			position, target_position,
			0.25,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			if m_carry:
				n_TweenMovement.interpolate_property(
				m_carry,"position",
				m_carry.position, position,
				0.25,
				Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

			n_TweenMovement.start()
		
	else:
		if(c[0].collider.collision_layer != LAYER.WALL):
			m_focus = c[0].collider
			
			if not n_SFXPlayerSelect.playing and m_focus != last_focus:
				n_SFXPlayerSelect.play()
				
			match m_focus.collision_layer:
				LAYER.CARRYABLE:
					if m_carry == m_focus:
						n_Cursor.set_text("Drop")
					else:
						n_Cursor.set_text("Carry")
				LAYER.WATER:
					n_Cursor.set_text("Bridge")
				LAYER.TREE:
					n_Cursor.set_text("Cut Down")
				LAYER.ROCK:
					n_Cursor.set_text("Break")
				LAYER.HOLE:
					n_Cursor.set_text("Fill")
			
			n_Cursor.position = direction
			n_Cursor.visible = true
			

func clear_focus():
	m_focus = null
	n_Cursor.visible = false

func _on_TweenMovement_tween_completed(object, key):
	m_state = STATE_IDLE

func to_end():
	clear_focus()
	m_state = STATE_END

