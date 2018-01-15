local category = {
  type = "resource-category",
  name = "yaiom-hydraulic-fracturing"
}

local drill = {
  type = "mining-drill",
  name = "yaiom-fracturing-drill",
  icons = {{
    icon = "__base__/graphics/icons/pumpjack.png",
    tint = util.color "00bfff7f"
  }},
  icon_size = 32,
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 1, result = "yaiom-fracturing-drill"},
  resource_categories = {"yaiom-hydraulic-fracturing"},
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
    emissions = 0.2 / 1.5,
    usage_priority = "secondary-input"
  },
  energy_usage = "340kW",
  input_fluid_box = {
    production_type = "input-output",
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 1,
    height = 2,
    base_level = -1,
    pipe_connections = {
      {position = {-1.5, 0.5}},
      {position = {1.5, 0.5}},
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
  mining_speed = 1,
  mining_power = 2,
  resource_searching_radius = 0.99,
  vector_to_place_result = {0, 0},
  module_specification = {
    module_slots = 2
  },
  radius_visualisation_picture = {
    filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
    width = 12,
    height = 12
  }
}
drill.animations = table.deepcopy(data.raw["mining-drill"]["burner-mining-drill"].animations)
for _, a in pairs(drill.animations) do
  for _, l in pairs(a.layers) do
    l.tint = util.color "00bfff"
    if l.hr_version then l.hr_version.tint = util.color "00bfff" end
  end
end
log(serpent.block(drill.icons))


local item = {
  type = "item",
  name = "yaiom-fracturing-drill",
  flags = {"goes-to-quickbar"},
  icons = {{
    icon = "__base__/graphics/icons/pumpjack.png",
    tint = util.color "00bfff"
  }},
  icon_size = 32,
  stack_size = 20,
  place_result = "yaiom-fracturing-drill",
  subgroup = "extraction-machine",
  order = "b[fluids]-z[yaiom]-a[drill]",
}

local recipe = {
  type = "recipe",
  name = "yaiom-fracturing-drill",
  energy_required = 5,
  ingredients = {
    {"burner-mining-drill", 1},
    {"steel-plate", 5},
    {"iron-gear-wheel", 10},
    {"advanced-circuit", 5},
    {"pipe", 10}
  },
  result = "yaiom-fracturing-drill",
  enabled = false,
  -- order = "z[yaiom]-a[drill]"
}

local technology = {
  type = "technology",
  name = "yaiom-hydraulic-fracturing",
  icon_size = 128,
  icon = "__base__/graphics/technology/nuclear-power.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracturing-drill"
    },
    {
      type = "nothing",
      effect_description = {"technology-effect.yaiom-fracturing-scan"}
    }
  },
  prerequisites = {"rocket-silo", "advanced-material-processing-2"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1},
      {"high-tech-science-pack", 1},
      {"space-science-pack", 1}
    },
    time = 60,
    count = 1000
  },
  order = "z[yaiom]-b"
}

data:extend {category, drill, item, recipe, technology}
