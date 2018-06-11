extends Panel

func _on_Back_pressed():
    """
    Called when the back button is pressed.
    """
    get_tree().change_scene("res://menus/main/MainMenu.tscn")

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
