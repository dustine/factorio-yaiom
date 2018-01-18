require "fracking-beacon"
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
  icon = "__yaiom__/graphics/fracking/technology.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracking-radar"
    }
  },
  prerequisites = {"electric-energy-accumulators-1", "advanced-electronics-2"},
  unit = {
    ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1}
    },
    time = 30,
    count = 500
  },
  order = "z[yaiom]-a[fracking]-a"
}

local technology_automated = {
  type = "technology",
  name = "yaiom-fracking-automated",
  icon_size = 128,
  icon = "__yaiom__/graphics/fracking/technology.png",
  effects = {
    {
      type = "unlock-recipe",
      recipe = "yaiom-fracking-beacon"
    }
  },
  prerequisites = {"yaiom-fracking", "effect-transmission"},
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
    count = 3000
  },
  order = "z[yaiom]-a[fracking]-b"
}

data:extend {category, technology, technology_automated}
