extends Node

const SAVE_PATH = "user://save.json"
const DEFAULT_DATA = { "points": 0 }
var _save_data = _load_save()

var points setget set_points, get_points

func set_points(new_points):
    """
    Sets the saved amount of points.
    """
    _save_data.points = new_points
    _store_save()

func get_points():
    """
    Gets the saved amount of points.
    """
    return _save_data.points

func save_data():
    """
    Saves all data. Normally this is done by default when modifying any save
    data.
    """
    _store_save()

func reset_data():
    """
    Resets all save data.
    """
    _save_data = DEFAULT_DATA
    _store_save()

func _ready():
    randomize()

func _notification(what):
    # save data before quitting
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        _store_save()

func _load_save():
    """
    Loads the save file from JSON format.
    """
    var file = File.new()
    var data = DEFAULT_DATA
    if file.file_exists(SAVE_PATH):
        file.open(SAVE_PATH, File.READ)
        data = parse_json(file.get_line())
        file.close()
    return data

func _store_save():
    """
    Stores the save file as JSON format.
    """
    var file = File.new()
    var error = file.open(SAVE_PATH, File.WRITE)
    if error == OK:
        file.store_string(to_json(_save_data))
    else:
        print("error opening save file: ", error)
    file.close()
