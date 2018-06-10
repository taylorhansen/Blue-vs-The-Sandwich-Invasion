extends Area2D

# emitted when hit by an enemy
signal hit()

const FIREBALL = preload("res://fireball/Fireball.tscn")
const FIREBALL_SOUNDS = [
    preload("res://sounds/Explosion1.wav"),
    preload("res://sounds/Explosion2.wav"),
    preload("res://sounds/Explosion3.wav"),
    preload("res://sounds/Explosion4.wav"),
    preload("res://sounds/Explosion5.wav")
]

# bounding rectangle that the player can move in
# right now just a 32px margin on all sides
const BOUNDS = Rect2(Vector2(32, 32), Vector2(480, 480))

# initial dash speed in pixels/second
const DASH_SPEED = 500

# deceleration of dash in pixels/second/second
const DASH_DECAY = 1000

# player movement speed in pixels/second
export(float) var MOVEMENT_SPEED = 100

# fireball speed in pixels/second
export(float) var FIREBALL_SPEED = 500

var _velocity = Vector2()
var _is_dashing = false

func _ready():
    $HatAnimation.play("Hat")

func _process(delta):
    # move around
    if not _is_dashing:
        # can use arrow keys
        _velocity = MOVEMENT_SPEED * \
            Vector2(_get_horizontal_input(), _get_vertical_input())
    
    transform.origin += _velocity * delta
    
    if _is_dashing:
        # decay the dash velocity
        print(_velocity)
        _velocity = _velocity.normalized() * (_velocity.length() - DASH_DECAY * delta)
        if _velocity.length() < MOVEMENT_SPEED:
            # once it gets back down to movement speed, we're no longer dashing
            _is_dashing = false
            $DashCooldown.start()
    
    # clamp position within the boundaries
    transform.origin.x = clamp(transform.origin.x, BOUNDS.position.x, \
        BOUNDS.size.x)
    transform.origin.y = clamp(transform.origin.y, BOUNDS.position.y, \
        BOUNDS.size.y)
    
    # face towards the mouse
    look_at(get_global_mouse_position())
    
    # shoot a fireball
    # this can only happen if the fireball shooting animation is over
    if Input.is_action_pressed("shoot_fireball") and \
        not $HandAnimation.is_playing():
        $HandAnimation.play("ShootFireball")

func _input(event):
    if event.is_action_pressed("dash") and _can_dash():
        _dash()

func _on_area_entered(area):
    """
    Called when another area collides with this one.
    """
    if area.is_in_group("enemies"):
        # player was hit by an enemy
        emit_signal("hit")
        # enemy also dies as a result
        area.emit_signal("dead")

func _get_horizontal_input():
    """
    Gets the horizontal input direction: -1 for left, 1 for right, 0 for none.
    """
    return int(Input.is_action_pressed("move_right")) - \
        int(Input.is_action_pressed("move_left"))

func _get_vertical_input():
    """
    Gets the vertical input direction: -1 for up, 1 for down, 0 for none.
    """
    return int(Input.is_action_pressed("move_down")) - \
        int(Input.is_action_pressed("move_up"))

func shoot_fireball():
    """
    Causes the player to shoot a fireball. Called by HandAnimation.
    """
    var fireball = FIREBALL.instance()
    fireball.global_transform = global_transform
    fireball.global_position = global_position
    fireball.speed = FIREBALL_SPEED
    $Fireballs.add_child(fireball)
    
    # play a random fireball sound
    $FireballSound.stream = FIREBALL_SOUNDS[randi() % FIREBALL_SOUNDS.size()]
    $FireballSound.play()

func _can_dash():
    """
    Checks whether or not the player is able to dash.
    """
    return global.is_unlocked("dash") and not _is_dashing and \
        $DashCooldown.is_stopped()

func _dash():
    """
    Performs a dash.
    """
    # set an impulse for the dash
    _velocity = DASH_SPEED * transform.x.normalized()
    _is_dashing = true
