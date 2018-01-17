local entity = table.deepcopy(data.raw["mining-drill"]["burner-mining-drill"])
entity.name = "yaiom-fracking-drill"
entity.icon = nil
entity.icons = {{
    icon = "__base__/graphics/icons/pumpjack.png",
    tint = util.color "00bfff"
  }}
entity.minable.result = "yaiom-fracking-drill"
entity.resource_categories = {"yaiom-fracking"}
entity.energy_source = {
    type = "electric",
    -- will produce this much * energy pollution units per tick
    emissions = 0.2 / 1.5,
    usage_priority = "secondary-input"
  }
entity.energy_usage = "340kW"
entity.input_fluid_box = {
  production_type = "input-output",
  pipe_picture = assembler2pipepictures(),
  pipe_covers = pipecoverspictures(),
  base_area = 1,
  height = 2,
  base_level = -1,
  pipe_connections = {
    {position = {-1.5, 0.5}},
    {position = {1.5, -0.5}},
    {position = {0.5, 1.5}}
  }
}
entity.output_fluid_box = {
  base_area = 1,
  base_level = 1,
  pipe_covers = pipecoverspictures(),
  pipe_connections = {
    {position = {-0.5, -1.5}}
  }
}
entity.mining_speed = 1
entity.mining_power = 2
-- entity.resource_searching_radius = 0.99
entity.module_slots = 2
entity.radius_visualisation_picture = {
  filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
  width = 12,
  height = 12
}
for _, a in pairs(entity.animations) do
  local l = a.layers[1]
  l.tint = util.color "00bfff"
  l.hr_version.tint = util.color "00bfff"
end

local item = {
  type = "item",
  name = "yaiom-fracking-drill",
  flags = {"goes-to-quickbar"},
  icons = {{
    icon = "__base__/graphics/icons/pumpjack.png",
    tint = util.color "00bfff"
  }},
  icon_size = 32,
  stack_size = 20,
  place_result = "yaiom-fracking-drill",
  subgroup = "extraction-machine",
  order = "b[fluids]-z[yaiom]-a[fracking]-a[drill]",
}

local recipe = {
  type = "recipe",
  name = "yaiom-fracking-drill",
  energy_required = 5,
  ingredients = {
    {"burner-mining-drill", 1},
    {"steel-plate", 5},
    {"iron-gear-wheel", 10},
    {"advanced-circuit", 5},
    {"pipe", 10}
  },
  result = "yaiom-fracking-drill",
  enabled = false,
  -- order = "z[yaiom]-a[drill]"
}

data:extend{entity, item, recipe}