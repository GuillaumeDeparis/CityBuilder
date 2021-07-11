extends Node2D

#	var tileset = OrgMap.get_tileset()
#	var arrayTile = tileset.get_tiles_ids()
#	for tile in arrayTile:
#		print(tileset.tile_get_texture(tile).get_path().get_file())
#	var pos = get_global_mouse_position()
#	if event is InputEventMouseMotion:
#		OrgMap.set_cellv(pos, 0)

func _on_Node2D_updateMousePosition():
	var pos = get_global_mouse_position()

