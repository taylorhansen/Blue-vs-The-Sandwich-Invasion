extends Node

signal wave_changed

const ENEMY = preload("res://enemies/sandwich/Sandwich.tscn")

onready var player = get_parent().get_node("Player")

# current wave
var wave = 0

# amount of enemies to spawn
var to_spawn = 0

# amount of enemies that have been spawned
var spawned = 0

# amount of enemies that are killed
var killed = 0

func _ready():
    _next_wave()

func _on_SpawnTimer_timeout():
    """
    Called when the SpawnTimer runs out to spawn a new enemy.
    """
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
    enemy.connect("dead", self, "_on_enemy_dead")
    enemy.connect("fired", get_parent(), "_on_Sandwich_fired")
    add_child(enemy)
    
    # update spawn counter
    spawned += 1
    if spawned >= to_spawn:
        # current wave has finished spawning enemies
        $SpawnTimer.stop()

func _on_enemy_dead():
    """
    Called when an enemy is killed.
    """
    killed += 1
    if killed >= to_spawn:
        # all enemies have been killed
        _next_wave()

func _next_wave():
    """
    Advances to the next wave.
    """
    $SpawnTimer.start()
    wave += 1
    # amount of enemies increases linearithmically
    to_spawn = int(wave * log(wave + 1) + 1)
    spawned = 0
    killed = 0
    # SpawnTimer period decays exponentially
    $SpawnTimer.wait_time = 2.0 / wave
    print("spawn time: ", $SpawnTimer.wait_time, " to_spawn: ", to_spawn)
    emit_signal("wave_changed")
