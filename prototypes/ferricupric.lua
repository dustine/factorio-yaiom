local color = function(alpha)
  local c = util.color "c3ad7d"
  if alpha then c.alpha = alpha end
  return c 
end

local noise_layer = {
  type = "noise-layer",
  name = "yaiom-ferricupric"
}

local control = {
  type = "autoplace-control",
  name = "yaiom-ferricupric",
  richness = true,
  order = "b-a",
  category = "resource"
}

local ore = {
  type = "resource",
  name = "yaiom-ferricupric",
  icon = "__yaiom__/graphics/ferricupric-icon.png",
  icon_size = 32,
  flags = {"placeable-neutral"},
  collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  category = "yaiom-hydraulic-fracturing",
  order = "z[yaiom]-a",
  infinite = true,
  highlight = true,
  infinite_depletion_amount = 1,
  minimum = 6000,
  normal = 6000,
  tree_removal_probability = 0,
  cliff_removal_probability = 0,
  minable = {
    hardness = 1,
    mining_time = 1,
    mining_particle = "stone-particle",
    results = {{
      type = "fluid",
      name = "yaiom-ferricupric",
      amount_min = 1,
      amount_max = 1,
      probability = 1
    }},
    fluid_amount = 10,
    required_fluid = "light-oil"
  },
  autoplace = {
    order = "z[yaiom]-a",
    control = "yaiom-ferricupric",
    sharpness = 1,
    richness_multiplier = 6000*5, -- 3000
    richness_multiplier_distance_bonus = 300, -- 30
    richness_base = 6000, -- 500
    -- coverage = 0.003 / 3 * 1.41, -- (0, 1], 0.0002 / 3
    coverage = 1,
    peaks = {{
      noise_layer = "yaiom-ferricupric",
      noise_octaves_difference = -0.85 * 3, -- [?,?], -0.85
      noise_persistence = 0.4, -- [0,1], 0.4
    -- },{
    --   --no uranium in the starting area
    --   influence = -1.0,
    --   starting_area_weight_optimal = 1,
    --   starting_area_weight_range = 0,
    --   starting_area_weight_max_range = 2,
    },},
  },
  stage_counts = {0},
  stages = {
    sheet = {
      filename = "__yaiom__/graphics/ferricupric.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      scale = 0.5,
      frame_count = 1,
      variation_count = 1
    }
  },
  map_color = color()
}

local fluid = table.deepcopy(data.raw.fluid["light-oil"])
fluid.name = "yaiom-ferricupric"
fluid.icon = "__yaiom__/graphics/ferricupric-fluid.png"
fluid.base_color = color()
fluid.order = "z[yaiom]-a"

local recipe_clean = {
  type = "recipe",
  name = "yaiom-ferricupric-clean",
  category = "oil-processing",
  enabled = false,
  energy_required = 6,
  ingredients = {
    {type = "fluid", name = "water", amount = 30},
    {type = "fluid", name = "yaiom-ferricupric", amount = 50}
  },
  results = {
    {type = "item", name = "yaiom-ferricupric", amount = 4},
    {type = "item", name = "coal", amount = 1}
  },
  main_product = "yaiom-ferricupric",
  subgroup = "raw-material",
  order = "z[yaiom]-b[ferricupric]-a[ore]",
  crafting_machine_tint =
    {
      primary = color(0),
      secondary = {r = 0.795, g = 0.805, b = 0.605, a = 0.000}, -- #cacd9a00
      tertiary = util.color("ccc0")
    }
}

local item = {
  type = "item",
  name = "yaiom-ferricupric",
  icon = "__yaiom__/graphics/ferricupric-icon.png",
  icon_size = 32,
  flags = {},
  stack_size = 50,
  subgroup = "raw-resource",
  order = "z[yaiom]-a[ferricupric]",
}

local recipe_iron = {
  type = "recipe",
  name = "yaiom-ferricupric-iron",
  category = "centrifuging",
  enabled = false,
  energy_required = 50,
  ingredients = {
    {type = "item", name = "yaiom-ferricupric", amount = 100},
    {type = "item", name = "uranium-235", amount = 1}
  },
  results = {
    {type = "item", name = "iron-ore", amount = 80},
    {type = "item", name = "copper-ore", amount = 20},
    {type = "item", name = "uranium-238", amount = 1},
  },
  icon = "__base__/graphics/icons/icons-new/iron-ore.png",
  icon_size = 32,
  subgroup = "raw-material",
  order = "z[yaiom]-b[ferricupric]-b[iron]",
  allow_decomposition = false
}

local recipe_copper = {
  type = "recipe",
  name = "yaiom-ferricupric-copper",
  category = "centrifuging",
  enabled = false,
  energy_required = 50,
  ingredients = {
    {type = "item", name = "yaiom-ferricupric", amount = 100},
    {type = "item", name = "uranium-235", amount = 1}
  },
  results = {
    {type = "item", name = "copper-ore", amount = 80},
    {type = "item", name = "iron-ore", amount = 20},
    {type = "item", name = "uranium-238", amount = 1},
  },
  icon = "__base__/graphics/icons/icons-new/copper-ore.png",
  icon_size = 32,
  subgroup = "raw-material",
  order = "z[yaiom]-b[ferricupric]-c[copper]",
  allow_decomposition = false
}

local technology = {
  type = "technology",
  name = "yaiom-ferricupric",
  icon_size = 128,
  icon = "__base__/graphics/technology/nuclear-power.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-ferricupric-clean"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-ferricupric-iron"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-ferricupric-copper"
    }
  },
  prerequisites = {"yaiom-hydraulic-fracturing"},
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
    count = 6000
  },
  order = "z[yaiom]-b"
}

data:extend {noise_layer, control, ore, fluid, item, recipe_clean, recipe_iron, recipe_copper, technology}
