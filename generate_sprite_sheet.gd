extends Node

const SAVE_PATH = "res://assets/color_blocks_sprite_sheet.png"

const LIGHT_GREY = Color("#dddddd")
const DARK_GREY = Color("#0d0d0d")
const AUTUMN = Color("#8f4b3d")
const DARK_BROWN = Color("#503530")
const BROWN = Color("#78443a")
const DARK_BLUE = Color("#3d3d8f")
const YELLOW = Color("#bfaa40")

var colors = [
	LIGHT_GREY,
	DARK_GREY,
	AUTUMN,
	DARK_BROWN,
	BROWN,
	DARK_BLUE,
	YELLOW
]

@export var block_size: int = 32
@export var grid_size: Vector2i = Vector2i(6, 6)  # 6x6 for 36 blocks
@export var regenerate: bool = false: set = _regenerate
@export var save: bool = false: set = _save_sprite_sheet

func _ready():
	generate_sprite_sheet()
	_save_sprite_sheet()

func _regenerate(_value = true):
	generate_sprite_sheet()

func generate_sprite_sheet():
	for child in get_children():
		child.queue_free()
	
	for i in range(grid_size.y):
		for j in range(grid_size.x):
			var index = i * grid_size.x + j
			if index >= colors.size():
				break
				
			var block = ColorRect.new()
			block.size = Vector2(block_size, block_size)
			block.position = Vector2(j * block_size, i * block_size)
			block.color = colors[index]
			add_child(block)

func _save_sprite_sheet(_value = true):
	save_sprite_sheet()
func save_sprite_sheet():
	var image = Image.create(
		grid_size.x * block_size,
		grid_size.y * block_size,
		false,
		Image.FORMAT_RGBA8
	)
	
	for i in range(grid_size.y):
		for j in range(grid_size.x):
			var index = i * grid_size.x + j
			if index >= colors.size():
				break
			
			for y in range(block_size):
				for x in range(block_size):
					var pixel_x = j * block_size + x
					var pixel_y = i * block_size + y
					image.set_pixel(pixel_x, pixel_y, colors[index])
	
	# Save the image
	var err = image.save_png(SAVE_PATH)
	if err != OK:
		print("Error saving sprite sheet:", err)
	else:
		print("Sprite sheet saved successfully!")
