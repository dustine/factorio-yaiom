data:extend{{
  type = "fluid",
  name = "yaiom-orichalcum-sludge",
  icon = "__yaiom__/graphics/orichalcum/sludge.png",
  icon_size = 32,
  base_color = util.color "c3ad7d",
  flow_color = util.color "735f35",
  order = "z[yaiom]-b[orichalcum]-b[sludge]",
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
  order = "z[yaiom]-b[orichalcum]-0-a[filtering]",
--############################################################################--
--                                   TIER 1                                   --
--############################################################################--
},{
  type = "recipe",
  name = "yaiom-orichalcum-dust-sorting",
  enabled = false,
  energy_required = 1,
  ingredients = {
    {type = "item", name = "yaiom-orichalcum", amount = 3},
  },
  result = "yaiom",
  order = "z[yaiom]-b[orichalcum]-1-b[sorting]",
--############################################################################--
--                                   TIER 2                                   --
--############################################################################--
},{
  type = "item",
  name = "yaiom-irradiated-orichalcum",
  icon = "__yaiom__/graphics/orichalcum/irradiated.png",
  icon_size = 32,
  flags = {"hidden"},
  stack_size = 50,
  subgroup = "intermediate-product",
  order = "r[uranium-processing]-c[kovarex-enrichment-process]-z[yaiom]-b[orichalcum]-2-a[irradiated]"
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
  order = "z[yaiom]-b[orichalcum]-2-a[irradiation]",
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-0-1",
  enabled = false,
  energy_required = 1.5,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 4},
  },
  result = "yaiom",
  order = "z[yaiom]-b[orichalcum]-2-b[sorting]-0-1",
  allow_decomposition = false,
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-1-1",
  enabled = false,
  energy_required = 2,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 5},
    -- {type = "item", name = "catalysator-brown", amount = 1},
  },
  result = "yaiom",
  order = "z[yaiom]-b[orichalcum]-2-b[sorting]-1-1",
  allow_decomposition = false,
},{
  type = "recipe",
  name = "yaiom-orichalcum-ore-sorting-1-2",
  enabled = false,
  energy_required = 2,
  ingredients = {
    {type = "item", name = "yaiom-irradiated-orichalcum", amount = 5},
    -- {type = "item", name = "catalysator-brown", amount = 1},
  },
  result = "yaiom",
  order = "z[yaiom]-b[orichalcum]-2-b[sorting]-1-2",
  allow_decomposition = false,
},{
  type = "technology",
  name = "yaiom-advanced-orichalcum-2",
  enabled = false,
  icon = "__yaiom__/graphics/orichalcum/technology-advanced.png",
  icon_size = 128,
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-orichalcum-irradiation"
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
      recipe = "yaiom-orichalcum-ore-sorting-1-2"
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