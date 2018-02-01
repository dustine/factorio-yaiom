local noise_layer = {
  type = "noise-layer",
  name = "yaiom-orichalcum"
}

local control = {
  type = "autoplace-control",
  name = "yaiom-orichalcum",
  richness = true,
  order = "b-b-z[yaiom]-b[orichalcum]",
  category = "resource"
}

local entity = {
  type = "resource",
  name = "yaiom-orichalcum",
  icon = "__yaiom__/graphics/orichalcum/icon.png",
  icon_size = 32,
  flags = {"placeable-neutral"},
  collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  category = "yaiom-fracking",
  order = "z[yaiom]-b[orichalcum]",
  infinite = true,
  highlight = true,
  infinite_depletion_amount = 1,
  minimum = 1000,
  normal = 2000,
  enable_cliff_removal = false,
  tree_removal_probability = 0,
  cliff_removal_probability = 0,
  minable = {
    hardness = 1,
    mining_time = 1,
    mining_particle = "stone-particle",
    results = {
      {
        type = "fluid",
        name = "yaiom-orichalcum-fluid",
        amount = 1
      }
    },
    fluid_amount = settings.startup["yaiom-equivalent-exchange"].value and 5 or 10,
    required_fluid = "light-oil"
  },
  autoplace = {
    -- z so it spawns beneath all other ores
    order = "z[yaiom]-b[orichalcum]",
    control = "yaiom-orichalcum",
    sharpness = 1,
    richness_multiplier = 750, -- 3000
    richness_multiplier_distance_bonus = 30, -- 30
    richness_base = 1000, -- 500
    coverage = 0.003 / 3, -- (0, 1], 0.0002 / 3
    -- coverage = 1,
    peaks = {
      {
        noise_layer = "yaiom-orichalcum",
        noise_octaves_difference = -0.85 * 3, -- [?,?], -0.85
        noise_persistence = 0.4 -- [0,1], 0.4
      }
    }
  },
  stage_counts = {0},
  stages = {
    sheet = {
      filename = "__yaiom__/graphics/orichalcum/entity.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 1,
      variation_count = 1,
      hr_version = {
        filename = "__yaiom__/graphics/orichalcum/hr-entity.png",
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
fluid.name = "yaiom-orichalcum-fluid"
fluid.icon = "__yaiom__/graphics/orichalcum/fluid.png"
fluid.base_color = util.color "c3ad7d"
-- fluid.flow_color = util.color "a78a4d"
fluid.flow_color = util.color "735f35"
fluid.order = "z[yaiom]-b[orichalcum]-a[base]"

--############################################################################--
--                                   TIER 0                                   --
--############################################################################--

local recipe_cleaning = {
  type = "recipe",
  name = "yaiom-orichalcum-cleaning",
  category = "chemistry",
  icon = "__yaiom__/graphics/orichalcum/recipe-cleaning.png",
  icon_size = 32,
  enabled = false,
  energy_required = 6,
  ingredients = {
    {type = "fluid", name = "water", amount = 30},
    {type = "fluid", name = "yaiom-orichalcum-fluid", amount = 30}
  },
  results = {
    {type = "fluid", name = "petroleum-gas", amount = 20},
    {type = "item", name = "iron-ore", amount = 1, probability = 0.9},
    {type = "item", name = "copper-ore", amount = 1, probability = 0.9}
  },
  subgroup = "fluid-recipes",
  allow_decomposition = false,
  order = "z[yaiom]-b[orichalcum]-0-a[cleaning]",
  crafting_machine_tint = {
    primary = util.color "c3ad7d",
    secondary = {r = 0.795, g = 0.805, b = 0.605, a = 0.000}, -- #cacd9a00
    tertiary = util.color("ccc0")
  }
}

local technology = {
  type = "technology",
  name = "yaiom-orichalcum",
  icon_size = 128,
  icon = "__yaiom__/graphics/orichalcum/technology.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracking-drill"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-cleaning"
    }
  },
  prerequisites = {"yaiom-fracking", "advanced-material-processing-2"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1}
    },
    time = 30,
    count = 1000
  },
  order = "z[yaiom]-b[orichalcum]-0"
}

--############################################################################--
--                                   TIER 1                                   --
--############################################################################--

local item = {
  type = "item",
  name = "yaiom-orichalcum",
  icon = "__yaiom__/graphics/orichalcum/icon.png",
  icon_size = 32,
  flags = {},
  stack_size = 50,
  subgroup = "raw-resource",
  order = "z[yaiom]-b[orichalcum]-1-a[ore]"
}

local recipe_process = {
  type = "recipe",
  name = "yaiom-orichalcum-processing",
  category = "oil-processing",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "fluid", name = "water", amount = 50},
    {type = "fluid", name = "yaiom-orichalcum-fluid", amount = 100}
  },
  results = {
    {type = "fluid", name = "light-oil", amount = 35},
    {type = "item", name = "yaiom-orichalcum", amount = 10},
    {type = "item", name = "coal", amount = 5}
  },
  main_product = "yaiom-orichalcum",
  subgroup = "fluid-recipes",
  order = "a[oil-processing]-z[yaiom]-b[orichalcum]-1-a[processing]"
}

local recipe_iron = {
  type = "recipe",
  name = "yaiom-orichalcum-iron",
  category = "centrifuging",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-orichalcum", amount = 50},
    {type = "item", name = "uranium-fuel-cell", amount = 1}
  },
  results = {
    {type = "item", name = "iron-ore", amount = 40},
    {type = "item", name = "copper-ore", amount = 10},
    {type = "item", name = "used-up-uranium-fuel-cell", amount = 1}
  },
  icon = "__base__/graphics/icons/icons-new/iron-ore.png",
  icon_size = 32,
  subgroup = "intermediate-product",
  order = "r[uranium-processing]-c[kovarex-enrichment-process]-z[yaiom]-b[orichalcum]-1-b[iron]",
  allow_decomposition = false
}

local recipe_copper = {
  type = "recipe",
  name = "yaiom-orichalcum-copper",
  category = "centrifuging",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-orichalcum", amount = 50},
    {type = "item", name = "uranium-fuel-cell", amount = 1}
  },
  results = {
    {type = "item", name = "copper-ore", amount = 40},
    {type = "item", name = "iron-ore", amount = 10},
    {type = "item", name = "used-up-uranium-fuel-cell", amount = 1}
  },
  icon = "__base__/graphics/icons/icons-new/copper-ore.png",
  icon_size = 32,
  subgroup = "intermediate-product",
  order = "r[uranium-processing]-c[kovarex-enrichment-process]-z[yaiom]-b[orichalcum]-1-c[copper]",
  allow_decomposition = false
}

local technology_advanced = {
  type = "technology",
  name = "yaiom-advanced-orichalcum-1",
  icon_size = 128,
  icon = "__yaiom__/graphics/orichalcum/technology-advanced.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-processing"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-iron"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-copper"
    }
  },
  prerequisites = {"yaiom-orichalcum", "nuclear-fuel-reprocessing"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1},
      {"high-tech-science-pack", 1}
    },
    time = 45,
    count = 2000
  },
  order = "z[yaiom]-b[orichalcum]-1"
}

data:extend {
  noise_layer,
  control,
  entity,
  fluid,
  recipe_cleaning,
  technology,
  item,
  recipe_process,
  recipe_iron,
  recipe_copper,
  technology_advanced
}
require "orichalcum-refining"