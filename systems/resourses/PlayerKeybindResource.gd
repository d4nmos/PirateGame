class_name PlayerKeybindResource

extends Resource

		#"left" : InputMap.action_get_events("left"),
		#"right" : InputMap.action_get_events("right"),
		#"backward" : InputMap.action_get_events("backward"),
		#"forward" : InputMap.action_get_events("forward"),
		#"inventory" : InputMap.action_get_events("inventory"),
		#"interact" : InputMap.action_get_events("interact")

const LEFT :  String = "left"
const RIGHT :  String = "right"
const BACKWARD :  String = "backward"
const FORWARD :  String = "forward"
const INVENTORY :  String = "inventory"
const INTERACT :  String = "interact"

@export var DEFAULT_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_RIGHT_KEY = InputEventKey.new()
@export var DEFAULT_BACKWARD_KEY = InputEventKey.new()
@export var DEFAULT_FORWARD_KEY = InputEventKey.new()
@export var DEFAULT_INVENTORY_KEY = InputEventKey.new()
@export var DEFAULT_INTERACT_KEY = InputEventKey.new()

var left_key = InputEventKey.new()
var right_key = InputEventKey.new()
var backward_key = InputEventKey.new()
var forward_key = InputEventKey.new()
var inventory_key = InputEventKey.new()
var interact_key = InputEventKey.new()
