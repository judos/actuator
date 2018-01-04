
require "libs.all"
require "libs.prototypes.all"
require "libs.control.functions"

require "constants"

require "control.directional-actuator"

---------------------------------------------------
-- Init
---------------------------------------------------

local function migration()
	local previousVersion = global.version
	if global.version ~= previousVersion then
		info("Previous version: "..previousVersion.." migrated to "..global.version)
	end
end

local function init()
	if not global then global = {} end
	if not global.version then global.version = modVersion end
	entities_init()
	gui_init()
	migration()
end

local function onLoad()
	entities_load()
end

script.on_init(init)
script.on_configuration_changed(init)
script.on_load(onLoad)

---------------------------------------------------
-- Tick
---------------------------------------------------
script.on_event(defines.events.on_tick, function(event)
	entities_tick()
	gui_tick()
end)

---------------------------------------------------
-- Building Entities
---------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	entities_build(event)
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	entities_build(event)
end)

---------------------------------------------------
-- Removing entities
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, function(event)
	entities_pre_mined(event)
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	entities_pre_mined(event)
end)

---------------------------------------------------
-- Others
---------------------------------------------------

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	entities_settings_pasted(event)
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	entities_marked_for_deconstruction(event)
end)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	entities_rotate(event)
end)

