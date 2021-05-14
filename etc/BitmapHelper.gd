extends Node


func get_bitmap_rect(original_bitmap : BitMap, rect : Rect2):
	var bm = BitMap.new()
	bm.create(rect.size)
	
	for x in range(rect.size.x):
		for y in range(rect.size.y):
			var pos = Vector2(x,y) 
			var bitmap_target = pos + rect.position
			if (pos + rect.position).x >= original_bitmap.get_size().x or (pos + rect.position).y >= original_bitmap.get_size().y:
				bm.set_bit(pos, false)
				continue
			bm.set_bit(pos, original_bitmap.get_bit(bitmap_target))
	return bm


func save_bitmap_as_image(bm : BitMap):
	var image = bitmap_to_image(bm)
	var h_m_s = str(OS.get_time()["hour"]) + str(OS.get_time()["minute"]) + str(OS.get_time()["second"])
	var image_name = h_m_s + ".png"
	var image_file_path = "res://testign/BitMap Visuals/"
	var error = image.save_png(image_file_path + image_name)
	if error != OK:
		print("uh oh, stinky, %s" % error)

func bitmap_to_image(bm : BitMap):
	var image = Image.new()
	image.create(bm.get_size().x, bm.get_size().y, false, Image.FORMAT_RGB8)
	image.lock()
	for x in range(bm.get_size().x):
		for y in range(bm.get_size().y):
			var pos = Vector2(x,y)
			var value = bm.get_bit(pos)
			if value:
				image.set_pixelv(pos, Color.black)
			else:
				image.set_pixelv(pos, Color.transparent)
	image.unlock()
	return image
