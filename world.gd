extends Node2D

class_name World

@onready var player = $Player
@onready var crate = preload("res://crate.tscn")
@onready var wall = preload("res://wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	## Create walls for the top and bottom boundaries:
	#var wall_instance = wall.instantiate()
	#var crate_instance = crate.instantiate()
	#
	#var screen_size = get_viewport_rect().size
	#create_boundary_wall(screen_size.x,screen_size.y,wall_instance)
	##spawn_obstacles(screen_size.x,screen_size.y,wall_instance)
	##var obstacle_count = randi_range(3,5)
	#var obstacle_count  = 1
	#for _i in range(obstacle_count):  # Generate 5 blocks initially
		#generate_block(screen_size,crate_instance)
	pass

func generate_block(screen_size,sprite_instance):
	var block_shape = randi() % 7  # Randomly choose a shape (0-6)
	var blocks = []
	
	var sprite = sprite_instance.get_child(0)
	var sprite_width = sprite.texture.get_size().x
	var sprite_height = sprite.texture.get_size().y

	match block_shape:
		0:  # I-shaped block
			blocks = [[0, 0], [1, 0], [2, 0], [3, 0]]
		1:  # O-shaped block
			blocks = [[0, 0], [1, 0], [0, 1], [1, 1]]
		2:  # T-shaped block
			blocks = [[0, 0], [1, 0], [2, 0], [1, 1]]
		3:  # L-shaped block
			blocks = [[0, 0], [1, 0], [2, 0], [2, 1]]
		4:  # J-shaped block
			blocks = [[0, 0], [1, 0], [2, 0], [0, 1]]
		5:  # S-shaped block
			blocks = [[0, 0], [1, 0], [1, 1], [2, 1]]
		6:  # Z-shaped block
			blocks = [[0, 1], [1, 1], [1, 0], [2, 0]]


	# Find a suitable position for the block:
	var suitable_position_found = false
	var base_pos = Vector2(0,0)
	var min_distance = sprite_width
	
	#for body in crate.get_overlapping_bodies():
		#if body.is_in_group("create"):
			#print(body)
	#while true:
		#base_pos.x = randi() % int(screen_size.x - sprite_width*2)
		#base_pos.y = randi() % int(screen_size.y - sprite_height*2)
		##print(base_pos)
		## Check for collisions with existing blocks:
		#if check_crate_collisions(sprite_instance):
			#print(base_pos,"colliding")
			#continue
		#else:
			#print(base_pos,"not colliding")
			#break
	
	# Create and position the block instances:
	for block_pos in blocks:
		var new_instance = sprite_instance.duplicate()
		print(new_instance)
		new_instance.position = Vector2(
			base_pos.x + (sprite_width * block_pos[0]),
			base_pos.y + (sprite_height * block_pos[1])
		)
		add_child(new_instance)

func crate_collision_handler(data):
	print(["data",data]);

func check_crate_collisions(crate):
	var is_colliding = false

	# 1. Check collision with walls:
	for wall in get_tree().get_nodes_in_group("walls"):  # Assuming walls are in a group
		if crate.is_colliding(wall):
			is_colliding = true
			break

	# 2. Check collision with player:
	var player = get_tree().get_nodes_in_group("player")[0]  # Assuming there's one player
	if crate.overlaps_body(player):
		is_colliding = true

	# 3. Check collision with other crates:
	for other_crate in get_tree().get_nodes_in_group("crates"):  # Assuming crates are in a group
		if crate != other_crate and crate.overlaps_body(other_crate):
			is_colliding = true
			break

	return is_colliding

func spawn_obstacles(boundary_x,boundary_y,sprite_instance):
	var sprite = sprite_instance.get_child(0)
	var sprite_width = sprite.texture.get_size().x
	var sprite_height = sprite.texture.get_size().y
	
	var num_obstacles = 10 
	var min_spacing = 70 

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
