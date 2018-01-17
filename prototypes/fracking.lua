require "fracking-drill"
require "fracking-radar"

local category = {
  type = "resource-category",
  name = "yaiom-fracking"
}

local technology = {
  type = "technology",
  name = "yaiom-fracking",
  icon_size = 128,
  icon = "__base__/graphics/technology/nuclear-power.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracking-drill"
    },
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracking-radar"
    },
    -- {
    --   type = "unlock-recipe",
    --   recipe = "yaiom-ferricupric-cleaning"
    -- }
    -- {
    --   type = "nothing",
    --   effect_description = {"technology-effect.yaiom-fracturing-scan"}
    -- }
  },
  prerequisites = {"oil-processing", "advanced-electronics-2", "advanced-material-processing-2"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
    },
    time = 30,
    count = 500
  },
  order = "z[yaiom]-a[fracking]"
}

data:extend {category, technology}
