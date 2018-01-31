data:extend{{
  type = "fluid",
  name = "yaiom-orichalcum-sludge",
  icon = "__yaiom__/graphics/orichalcum/fluid.png",
  icon_size = 32,
  base_color = util.color "c3ad7d",
  flow_color = util.color "735f35",
  order = "z[yaiom]-a[orichalcum]-b[sludge]",
  default_temperature = 25,
  heat_capacity = "1KJ",
  max_temperature = 100,
	pressure_to_speed_ratio = 0.4,
  flow_to_energy_ratio = 0.59,

--############################################################################--
--                                   TIER 0                                   --
--############################################################################--
},{
  type = "recipe",
  name = "yaiom-orichalcum-filtration",
  enabled = false,
  energy_required = 4,
  ingredients = {
    {type = "fluid", name = "yaiom-orichalcum-fluid", amount = 50},
  },
  results = {
    {type = "fluid", name = "yaiom-orichalcum-sludge", amount = 50}
  },
  category = "chemistry",
  main_product = "yaiom-orichalcum-sludge",
  order = "z[yaiom]-b[orichalcum]-c[iron]",
--############################################################################--
--                                   TIER 1                                   --
--############################################################################--
},{
  type = "recipe",
  name = "yaiom-orichalcum-dust-sorting",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-orichalcum", amount = 3},
  },
  result = "yaiom",
  -- results = {
  --   {type = "item", name = "angels-ore1", amount = 1},
  --   {type = "item", name = "angels-ore4", amount = 1},
  --   {type = "item", name = "slag", amount = 1},
  -- },
  -- main_product = "yaiom-orichalcum",
  order = "z[yaiom]-b[orichalcum]-c[iron]",
--############################################################################--
--                                   TIER 2                                   --
--############################################################################--
},{
  type = "item",
  name = "yaiom-irradiated-orichalcum",
  icon = "__yaiom__/graphics/orichalcum/icon.png",
  icon_size = 32,
  flags = {},
  stack_size = 50,
  subgroup = "raw-resource",
  order = "z[yaiom]-a[orichalcum]"
},{
  type = "recipe",
  name = "yaiom-orichalcum-irradiation",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-orichalcum", amount = 50},
    {type = "item", name = "uranium-fuel-cell", amount = 1}
  },
  results = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 50},
    {type = "item", name = "used-up-uranium-fuel-cell", amount = 1}
  },
  main_product = "yaiom-irradiated-orichalcum",
  order = "z[yaiom]-b[orichalcum]-c[iron]",
  allow_decomposition = false,
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-0-1",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 4},
  },
  result = "yaiom",
  -- results = {
  --   {type = "item", name = "angels-ore2", amount = 2},
  --   {type = "item", name = "angels-ore5", amount = 2},
  -- },
  order = "z[yaiom]-b[orichalcum]-c[iron]",
  allow_decomposition = false,
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-1-1",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 5},
    -- {type = "item", name = "catalysator-brown", amount = 1},
  },
  result = "yaiom",
  -- results = {
  --   {type = "item", name = "angels-ore1", amount = 4},
  --   {type = "item", name = "angels-ore5", amount = 1},
  -- },
  order = "z[yaiom]-b[orichalcum]-c[iron]",
  allow_decomposition = false,
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-1-2",
  enabled = false,
  energy_required = 5,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 5},
    -- {type = "item", name = "catalysator-brown", amount = 1},
  },
  result = "yaiom",
  -- results = {
  --   {type = "item", name = "angels-ore4", amount = 4},
  --   {type = "item", name = "angels-ore2", amount = 1},
  -- },
  order = "z[yaiom]-b[orichalcum]-c[iron]",
  allow_decomposition = false,
},{
  type = "technology",
  name = "yaiom-advanced-orichalcum-2",
  icon_size = 128,
  -- enabled = false,
  icon = "__yaiom__/graphics/orichalcum/technology-advanced.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-processing"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-ore-sorting-0-1"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-ore-sorting-1-1"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-ore-sorting-1-1"
    },
  },
  prerequisites = {"yaiom-advanced-orichalcum-1", "nuclear-fuel-reprocessing"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      {"production-science-pack", 1},
      {"high-tech-science-pack", 1}
    },
    time = 60,
    count = 2000
  },
  order = "z[yaiom]-b[orichalcum]-2"
}}