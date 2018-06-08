extends Node

# enemy scene
const ENEMY = preload("res://enemies/enemy/Enemy.tscn")

onready var player = $Player

func _process(delta):
    # seed the random number generator
    randomize()

func _on_SpawnTimer_timeout():
    # spawn an enemy on the perimeter of the viewport
    var bounds = get_viewport().size
    var pos
    var side = randi() % 4
    if side == 0: # top
        pos = Vector2(rand_range(0, bounds.x), 0)
    elif side == 1: # right
        pos = Vector2(0, rand_range(0, bounds.y))
    elif side == 2: # bottom
        pos = Vector2(rand_range(0, bounds.x), bounds.y)
    elif side == 3: # left
        pos = Vector2(bounds.x, rand_range(0, bounds.y))
    var enemy = ENEMY.instance()
    enemy.global_position = pos
    enemy.player = player
    $Enemies.add_child(enemy)
