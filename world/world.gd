extends Node

# enemy scene
const ENEMY = preload("res://enemies/enemy/Enemy.tscn")

onready var player = $Player

# current score
var score = 0

# amount of lives the player has
var lives = 3

func _ready():
    # initialize score label
    _update_score()
    
    # update the lives counter
    _update_lives()
    
    # seed the random number generator
    randomize()

func _on_SpawnTimer_timeout():
    # spawn an enemy
    var enemy = ENEMY.instance()
    
    # set its position along the perimeter of the viewport
    var pos
    var bounds = get_viewport().size
    var side = randi() % 4
    if side == 0: # top
        pos = Vector2(rand_range(0, bounds.x), 0)
    elif side == 1: # right
        pos = Vector2(0, rand_range(0, bounds.y))
    elif side == 2: # bottom
        pos = Vector2(rand_range(0, bounds.x), bounds.y)
    elif side == 3: # left
        pos = Vector2(bounds.x, rand_range(0, bounds.y))
    enemy.global_position = pos
    
    # other initialization
    enemy.player = player
    enemy.connect("fired", self, "_on_Enemy_fired")
    $Enemies.add_child(enemy)

func _on_Player_hit(enemy):
    """
    Called when the player is hit and loses a life.
    """
    enemy.queue_free()
    lives -= 1
    _update_lives()
    if lives <= 0:
        # TODO: game over
        pass

func _on_Enemy_fired():
    """
    Called when an enemy is "fired" or killed.
    """
    # increment score
    score += 1
    
    # update score label
    _update_score()

func _update_score():
    """
    Updates the score indicator in the HUD.
    """
    $HUD/Score.text = "Score: " + str(score)

func _update_lives():
    """
    Updates the life indicator in the HUD.
    """
    $HUD/Lives/Label2.text = "x" + str(lives)
