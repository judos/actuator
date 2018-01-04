data:extend({
	{
		type = "recipe",
		name = "directional-actuator",
		enabled = "false",
		ingredients = {
			{"copper-cable", 5},
			{"electronic-circuit", 5},
		},
		result = "directional-actuator"
	},
	{
		type = "item",
		name = "directional-actuator",
		icon = "__actuator__/graphics/actuator_icon.png",
		icon_size = 32,
		flags = { "goes-to-quickbar" },
		subgroup = "circuit-network",
		place_result="directional-actuator",
		order = "b[combinators]-e[directional-actuator]",
		stack_size= 50,
	}
})

local actuator = deepcopy(data.raw["inserter"]["inserter"])
local null = {}
local noPicture = {
	filename="__actuator__/graphics/empty.png",
	width = 0,
	height = 0,
	shift = {0, 0}
}

overwriteContent(actuator, {
	name = "directional-actuator",
	icon = "__actuator__/graphics/actuator_icon.png",
	minable = {hardness = 0.2, mining_time = 0.5, result = "directional-actuator"},
	collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	energy_per_movement = 17857,
	energy_per_rotation = 17857,
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = "50kW"
	},
	fast_replaceable_group = null,
	working_sound = {
		match_progress_to_activity = true,
		sound = {
			{
				filename = "__base__/sound/inserter-basic-1.ogg",
				volume = 0.0
			},
		}
	},
  hand_base_picture = noPicture,
	hand_closed_picture = noPicture,
	hand_open_picture = noPicture,
	hand_base_shadow  = noPicture,
	hand_closed_shadow = noPicture,
	hand_open_shadow = noPicture,
	pickup_position = {0, 0},
	insert_position = {0, 1},
	platform_picture = {
		sheet = {
			filename = "__actuator__/graphics/actuator.png",
			priority = "high",
			width = 72,
			height = 46,
			frame_count = 4,
			shift = {0, 0},
			direction_count = 4,
		}
	},
	circuit_wire_connection_point = {
		shadow = {
			red = {0.2, 0},
			green = {0.2, 0}
		},
		wire = {
			red = {0.0, -0.2},
			green = {0.0, -0.2}
		}
	},
},null)
data:extend({ actuator })

data:extend({
	{
		type = "simple-entity",
		name = "indicator-green",
		flags = {"placeable-off-grid"},
		drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
		render_layer = "object",
		max_health = 100,
		pictures = {
			{
				filename = "__actuator__/graphics/greenlamp.png",
				width = 11,
				height = 11,
				shift = {0,0},
			},
		}
	},
	{
		type = "simple-entity",
		name = "indicator-orange",
		flags = {"placeable-off-grid"},
		drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
		render_layer = "object",
		max_health = 100,
		pictures = {
			{
				filename = "__actuator__/graphics/orangelamp.png",
				width = 11,
				height = 11,
				shift = {0,0},
			},
		}
	},
	{
		type = "simple-entity",
		name = "indicator-red",
		flags = {"placeable-off-grid"},
		drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
		render_layer = "object",
		max_health = 100,
		pictures = {
			{
				filename = "__actuator__/graphics/redlamp.png",
				width = 11,
				height = 11,
				shift = {0,0},
			},
		}
	},
})

table.insert(data.raw["technology"]["circuit-network"].effects, { type = "unlock-recipe", recipe = "directional-actuator"})
