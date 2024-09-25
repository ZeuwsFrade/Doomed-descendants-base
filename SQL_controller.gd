extends Node

var database: SQLite

func _ready():
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()
	pass

func _process(_delta):
	pass


func _on_create_table_button_down():
	var table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auo_increment": true},
		"name" : {"data_type": "text"},
		"score" : {"data_type": "int"}
	}
	database.create_table("players", table)
	pass # Replace with function body.


func _on_insert_data_button_down() -> void:
	pass # Replace with function body.


func _on_select_data_button_down() -> void:
	pass # Replace with function body.


func _on_upload_data_button_down() -> void:
	pass # Replace with function body.


func _on_delete_data_button_down() -> void:
	pass # Replace with function body.


func _on_custom_select_button_down() -> void:
	pass # Replace with function body.
