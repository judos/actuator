-- Registering entity into system
local actuator = {}
local updateEveryXTicks = 10
local searchTargetEveryXTicks = 60

entities["directional-actuator"] = actuator

local entityBlacklist = table.set{  }
local entityTypeBlacklist = table.set{"container",
	"transport-belt",
	"underground-belt",
	"splitter",
	"electric-pole",
	"car", "tank", "locomotive", "cargo-wagon", "fluid-wagon",
	"straight-rail", "curved-rail", "train-stop", "rail-signal", "rail-chain-signal",
	"logistic-robot", "construction-robot",
	"player",
	"programmable-speaker",
	"lamp",
	"accumulator", "solar-panel",
	"heat-pipe",
}

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------
--------------------------------------------------
-- Migration
--------------------------------------------------
---------------------------------------------------
-- build and remove
---------------------------------------------------

function getAdjPos(entity)
	local dir = entity.direction
	local posX = entity.position.x
	local posY = entity.position.y
	if dir == 6 then 
		posX = posX + 1
	elseif dir == 2 then 
		posX = posX - 1
	elseif dir == 0 then 
		posY = posY + 1
	elseif dir == 4 then 
		posY = posY - 1
	end
	return {posX, posY}
end

function targetArea(position)
	return {
		{position[1]-0.5,position[2]-0.5},
		{position[1]+0.5,position[2]+0.5}
	}
end

actuator.build = function(entity)
	entity.get_or_create_control_behavior()
	local targetPos = getAdjPos(entity)
	local targetArea = targetArea(targetPos)
	local data = {
		targetArea = targetArea,
		state = false,
	}
	setIndicator(entity,data)
	scheduleAdd(entity, TICK_ASAP)
	return data
end

actuator.remove = function(data)
	if data.target ~= nil and data.target.valid then
		data.target.active = true
	end
	data.indicator.destroy()
end

function setIndicator(entity,data)
	if data.indicator ~= nil and data.indicator.valid then
		data.indicator.destroy()
	end
	local color = "indicator-orange"
	if data.target ~= nil and data.target.valid then
		info("setIndicator: "..data.target.name)
		if data.state then
			color = "indicator-green"
		else
			color = "indicator-red"
		end
	end
	data.indicator = entity.surface.create_entity{name = color, position = entity.position}
end


actuator.tick = function(entity,data)
	local prevTarget = data.target
	if data.target == nil or not data.target.valid then
		data.target = nil
		if not findTarget(entity,data) then
			setIndicator(entity,data)
			return searchTargetEveryXTicks
		end
	end

	local newState = false
	if entity.energy > 0 then
		newState = not entity.get_control_behavior().disabled
	end
	
	if newState ~= data.state or data.target ~= prevTarget then
		data.state = newState
		setIndicator(entity,data)
		data.target.active = newState
	end
	return updateEveryXTicks
end


function findTarget(entity,data)
	local adj = entity.surface.find_entities_filtered{area = data.targetArea, force = entity.force}
	for _,targetEntity in ipairs(adj) do
		if not entityBlacklist[targetEntity.name] and not entityTypeBlacklist[targetEntity.type] then
			data.target = targetEntity
			info("found: "..targetEntity.name.. " of type "..targetEntity.type)
			return true
		else
			info("can't use entity "..targetEntity.name.. " of type "..targetEntity.type)
		end
	end
	return false 
end

actuator.rotate = function(entity,data)
	if data.target ~= nil and data.target.valid then
		data.target.active = true
	end
	local targetPos = getAdjPos(entity)
	data.targetArea = targetArea(targetPos)
	data.target = nil
	setIndicator(entity,data)
end

