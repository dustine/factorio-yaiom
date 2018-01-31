local drill = {
  type = "mining-drill",
  name = "yaiom-fracking-drill",
  icons = {
    {
      icon = "__base__/graphics/icons/burner-mining-drill.png",
      tint = util.color "00bfff"
    }
  },
  icon_size = 32,
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 1, result = "yaiom-fracking-drill"},
  resource_categories = {"yaiom-fracking"},
  max_health = 200,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",
  collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
  selection_box = {{-1, -1}, {1, 1}},
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill.ogg",
      volume = 0.8
    }
  },
  vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
  energy_source = {
    type = "electric",
    -- will produce this much * energy pollution units per tick
    emissions = 1 / 9,
    usage_priority = "secondary-input"
  },
  energy_usage = "612kW",
  input_fluid_box = {
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
  },
  output_fluid_box = {
    base_area = 1,
    base_level = 1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      {position = {-0.5, -1.5}}
    }
  },
  mining_speed = 1.25,
  mining_power = 3,
  resource_searching_radius = 0.99,
  vector_to_place_result = {0, 0},
  module_specification = {
    module_slots = 4
  },
  -- allowed_effects = {"consumption", "speed", "pollution"},
  radius_visualisation_picture = {
    filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
    width = 12,
    height = 12
  }
}
drill.animations = table.deepcopy(data.raw["mining-drill"]["burner-mining-drill"].animations)
for _, a in pairs(drill.animations) do
  local l = a.layers[1]
  l.tint = util.color "00bfff"
  l.hr_version.tint = util.color "00bfff"
end

local item = {
  type = "item",
  name = "yaiom-fracking-drill",
  flags = {"goes-to-quickbar"},
  icons = {
    {
      icon = "__base__/graphics/icons/burner-mining-drill.png",
      tint = util.color "00bfff"
    }
  },
  icon_size = 32,
  stack_size = 20,
  place_result = "yaiom-fracking-drill",
  subgroup = "extraction-machine",
  order = "b[fluids]-z[yaiom]-a[fracking]-a[drill]"
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
  enabled = false
  -- order = "z[yaiom]-a[drill]"
}

data:extend {drill, item, recipe}
