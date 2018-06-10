extends Control

func _ready():
    _update_points()

func _on_Start_pressed():
    """
    Called when the start button is pressed.
    """
    get_tree().change_scene("res://world/World.tscn")

func _on_Upgrades_pressed():
    """
    Called when the upgrades button is pressed.
    """
    get_tree().change_scene("res://menus/upgrades/UpgradesMenu.tscn")

func _on_Quit_pressed():
    """
    Called when the quit button is pressed.
    """
    global.save_data()
    get_tree().quit()

func _on_ResetData_pressed():
    """
    Called when the reset data button is pressed.
    """
    global.reset_data()
    global.save_data()
    _update_points()

func _play_select():
    """
    Called when a button is clicked.
    """
    global.play_select()

func _play_hover():
    """
    Called when a button is hovered over.
    """
    global.play_hover()

func _update_points():
    """
    Updates the points label.
    """
    $Points.text = "Points: " + str(global.points)
