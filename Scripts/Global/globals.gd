extends Node
# health
var player_health = 100
var inv_manager
var player

enum {USELESS, PLACEABLE, CONSUMEABLE, WEAPON, TOOL}


## movement
## initial walk speed
#@export var SPEED = 200.0
## initial jump speed
#@export var JUMP_SPEED = -300.0
## maximum falling speed
#const VERTICAL_SPEED_LIMIT = 600
## sliding wall gravity (to make falling when colliding against wall slower)
#const SLIDING_GRAVITY = 200
## dash speed
#const DASH_SPEED = 300
## additional double jump speed
#const DOUBLE_JUMP_SPEED = -300
## initial speed to move away from the wall (to the opposite direction)
#const WALL_JUMP_SPEED_AGAINST_WALL = 200
## initial speed to move up from the wall
#const WALL_JUMP_SPEED_UPWARDS = -300
