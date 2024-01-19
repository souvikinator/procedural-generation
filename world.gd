extends Node2D

class_name World

@onready var player = $Player
@onready var wall = preload("res://wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create walls for the top and bottom boundaries:
	var wall_instance = wall.instantiate()
	var screen_size = get_viewport_rect().size
	create_boundary_wall(screen_size.x,screen_size.y,wall_instance)
	spawn_obstacles(screen_size.x,screen_size.y,wall_instance)

func spawn_obstacles(boundary_x,boundary_y,sprite_instance):
	var sprite = sprite_instance.get_child(0)
	var sprite_width = sprite.texture.get_size().x
	var sprite_height = sprite.texture.get_size().y
	
	var num_obstacles = 10  # Adjust the number of obstacles as needed
	var min_spacing = 70   # Minimum spacing between obstacles

	for i in range(num_obstacles):
		var obstacle_placed = false
		while not obstacle_placed:
			var x_pos = randi() % int(boundary_x - sprite_width)
			var y_pos = randi() % int(boundary_y - sprite_height)

			# Check for collisions with existing walls and player:
			if x_pos != player.position.x or y_pos != player.position.y:
				var obstacle_wall = wall.instantiate()
				obstacle_wall.position = Vector2(x_pos, y_pos)
				add_child(obstacle_wall)
				obstacle_placed = true

func create_boundary_wall(boundary_x,boundary_y,sprite_instance):
	var sprite = sprite_instance.get_child(0)
	var sprite_width = sprite.texture.get_size().x
	var sprite_height = sprite.texture.get_size().y
	# Calculate the number of walls needed for each side:
	var wall_count_x = ceil(boundary_x / sprite_width)
	var wall_count_y = ceil(boundary_y / sprite_height)

	# create wall on top and bottom border
	for i in range(boundary_x):
		var x_pos = i * sprite_width - sprite_width
		var top_wall = sprite_instance.duplicate()
		top_wall.position.x = x_pos
		top_wall.position.y = 0
		add_child(top_wall)

		var bottom_wall = sprite_instance.duplicate()
		bottom_wall.position.x = x_pos
		bottom_wall.position.y = boundary_y
		add_child(bottom_wall)

	for i in range(boundary_y):  # Add extra walls for corners
		var y_pos = i * sprite_height - sprite_height
		var left_wall = sprite_instance.duplicate()
		left_wall.position.x = 0
		left_wall.position.y = y_pos
		add_child(left_wall)

		var right_wall = sprite_instance.duplicate()
		right_wall.position.x = boundary_x
		right_wall.position.y = y_pos
		add_child(right_wall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
