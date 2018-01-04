for i, force in pairs(game.forces) do 
  force.reset_technologies() 
  if force.technologies["circuit-network"].researched then 
    force.recipes["directional-actuator"].enabled = true
  end
end