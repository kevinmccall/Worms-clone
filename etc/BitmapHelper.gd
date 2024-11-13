extends Node


func get_bitmap_rect(original_bitmap : BitMap, rect : Rect2):
	var bm = BitMap.new()
	bm.create(rect.size)
	var original_bm_size = original_bitmap.get_size()
	
	for x in range(rect.size.x):
		for y in range(rect.size.y):
			var pos = Vector2(x,y) 
			var bitmap_target = pos + rect.position
			if bitmap_target.x >= original_bm_size.x or bitmap_target.y >= original_bm_size.y:
				bm.set_bitv(pos, false)
				continue
			bm.set_bitv(pos, original_bitmap.get_bitv(bitmap_target))
	return bm


func save_bitmap_as_image(bm : BitMap):
	var image = bitmap_to_image(bm)
	var time = Time.get_time_dict_from_system()
	var h_m_s = str(time["hour"]) + str(time["minute"]) + str(time["second"])
	var image_name = h_m_s + ".png"
	var image_file_path = "res://testign/BitMap Visuals/"
	var error = image.save_png(image_file_path + image_name)
	if error != OK:
		print("uh oh, stinky, %s" % error)


func bitmap_to_image(bm : BitMap):
	var image = Image.create_empty(bm.get_size().x, bm.get_size().y, false, Image.FORMAT_LA8)
	for x in range(bm.get_size().x):
		for y in range(bm.get_size().y):
			var pos = Vector2i(x,y)
			var value = bm.get_bitv(pos)
			if value:
				image.set_pixelv(pos, Color.WHITE)
			else:
				image.set_pixelv(pos, Color.TRANSPARENT)
	return image
