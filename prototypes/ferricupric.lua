local noise_layer = {
  type = "noise-layer",
  name = "yaiom-ferricupric"
}

local control = {
  type = "autoplace-control",
  name = "yaiom-ferricupric",
  richness = true,
  order = "b-b-z[yaiom]-a[ferricupric]",
  category = "resource"
}

local entity = {
  type = "resource",
  name = "yaiom-ferricupric",
  icon = "__yaiom__/graphics/ferricupric-icon.png",
  icon_size = 32,
  flags = {"placeable-neutral"},
  collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  category = "yaiom-fracking",
  order = "z[yaiom]-b[ferricupric]",
  infinite = true,
  highlight = true,
  infinite_depletion_amount = 5,
  minimum = 1000,
  normal = 10000,
  enable_cliff_removal = false,
  tree_removal_probability = 0,
  cliff_removal_probability = 0,
  minable = {
    hardness = 1,
    mining_time = 1,
    mining_particle = "stone-particle",
    results = {{
      type = "fluid",
      name = "yaiom-ferricupric",
      amount_min = 10,
      amount_max = 10,
      probability = 1
    }},
    fluid_amount = 10,
    required_fluid = "light-oil"
  },
  autoplace = {
    -- z so it spawns beneath all other ores
    order = "z[yaiom]-a[ferricupric]",
    control = "yaiom-ferricupric",
    default_enabled = false,
    sharpness = 1,
    richness_multiplier = 20000, -- 3000
    richness_multiplier_distance_bonus = 500, -- 30
    richness_base = 5000, -- 500
    coverage = 0.003 / 3, -- (0, 1], 0.0002 / 3
    -- coverage = 1,
    peaks = {{
      noise_layer = "yaiom-ferricupric",
      noise_octaves_difference = -0.85 * 3, -- [?,?], -0.85
      noise_persistence = 0.4, -- [0,1], 0.4
    },},
  },
  stage_counts = {0},
  stages = {
    sheet = {
      filename = "__yaiom__/graphics/ferricupric.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 1,
      variation_count = 1,
      hr_version = {
        filename = "__yaiom__/graphics/hr-ferricupric.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        frame_count = 1,
        variation_count = 1,
        scale = 0.5
    }
    }
  },
  map_color = util.color "00bfff"
}

local fluid = table.deepcopy(data.raw.fluid["light-oil"])
fluid.name = "yaiom-ferricupric"
fluid.icon = "__yaiom__/graphics/ferricupric-fluid.png"
fluid.base_color = util.color "c3ad7d"
-- fluid.flow_color = util.color "a78a4d"
fluid.flow_color = util.color "735f35"
fluid.order = "z[yaiom]-a[ferricupric]"

--############################################################################--
--                                   TIER 1                                   --
--############################################################################--

local recipe_clean = {
  type = "recipe",
  name = "yaiom-ferricupric-cleaning",
  category = "chemistry",
  icon = "__yaiom__/graphics/ferricupric-cleaning-icon.png",
  icon_size = 32,
  enabled = false,
  energy_required = 6,
  ingredients = {
    {type = "fluid", name = "water", amount = 30},
    {type = "fluid", name = "yaiom-ferricupric", amount = 30}
  },
  results = {
    {type = "fluid", name = "petroleum-gas", amount = 20},
    {type = "item", name = "iron-ore", amount = 1, probability = 0.9},
    {type = "item", name = "copper-ore", amount = 1, probability = 0.9},
  },
  subgroup = "fluid-recipes",
  allow_decomposition = false,
  order = "z[yaiom]-a[ferricupric]-a[cleaning]",
  crafting_machine_tint = {
    primary = util.color "c3ad7d",
    secondary = {r = 0.795, g = 0.805, b = 0.605, a = 0.000}, -- #cacd9a00
    tertiary = util.color("ccc0")
  }
}

local technology_basic = {
  type = "technology",
  name = "yaiom-ferricupric",
  icon_size = 128,
  icon = "__base__/graphics/technology/nuclear-power.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-ferricupric-cleaning"
    },
  },
  prerequisites = {"yaiom-fracking"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1},
    },
    time = 60,
    count = 1000
  },
  order = "z[yaiom]-b[ferricupric]-a"
}

--############################################################################--
--                                   TIER 2                                   --
--############################################################################--

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

local recipe_process = {
  type = "recipe",
  name = "yaiom-ferricupric-processing",
  category = "oil-processing",
  enabled = false,
  energy_required = 6,
  ingredients = {
    {type = "fluid", name = "water", amount = 50},
    {type = "fluid", name = "yaiom-ferricupric", amount = 100}
  },
  results = {
    {type = "fluid", name = "light-oil", amount = 35},
    {type = "item", name = "yaiom-ferricupric", amount = 10},
    {type = "item", name = "coal", amount = 10},
  },
  main_product = "yaiom-ferricupric",
  subgroup = "fluid-recipes",
  order = "a[oil-processing]-z[yaiom]-a[ferricupric]-b[processing]",
}

local recipe_iron = {
  type = "recipe",
  name = "yaiom-ferricupric-iron",
  category = "centrifuging",
  enabled = false,
  energy_required = 50,
  ingredients = {
    {type = "item", name = "yaiom-ferricupric", amount = 250},
    {type = "item", name = "uranium-235", amount = 1}
  },
  results = {
    {type = "item", name = "iron-ore", amount = 200},
    {type = "item", name = "copper-ore", amount = 50},
    {type = "item", name = "uranium-238", amount = 1},
  },
  icon = "__base__/graphics/icons/icons-new/iron-ore.png",
  icon_size = 32,
  subgroup = "raw-material",
  order = "z[yaiom]-b[ferricupric]-c[iron]",
  allow_decomposition = false
}

local recipe_copper = {
  type = "recipe",
  name = "yaiom-ferricupric-copper",
  category = "centrifuging",
  enabled = false,
  energy_required = 50,
  ingredients = {
    {type = "item", name = "yaiom-ferricupric", amount = 250},
    {type = "item", name = "uranium-235", amount = 1}
  },
  results = {
    {type = "item", name = "copper-ore", amount = 200},
    {type = "item", name = "iron-ore", amount = 50},
    {type = "item", name = "uranium-238", amount = 1},
  },
  icon = "__base__/graphics/icons/icons-new/copper-ore.png",
  icon_size = 32,
  subgroup = "raw-material",
  order = "z[yaiom]-b[ferricupric]-d[copper]",
  allow_decomposition = false
}

local technology_advanced = {
  type = "technology",
  name = "yaiom-advanced-ferricupric",
  icon_size = 128,
  icon = "__base__/graphics/technology/nuclear-power.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-ferricupric-processing"
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
  prerequisites = {"yaiom-ferricupric", "nuclear-fuel-reprocessing"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1},
      {"high-tech-science-pack", 1},
    },
    time = 60,
    count = 2000
  },
  order = "z[yaiom]-b[ferricupric]-b"
}

data:extend {noise_layer, control, entity, fluid, recipe_clean, technology_basic, item, recipe_process, recipe_iron, recipe_copper, technology_advanced}
