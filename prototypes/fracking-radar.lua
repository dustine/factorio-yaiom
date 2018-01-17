local entity = table.deepcopy(data.raw.radar.radar)
entity.name = "yaiom-fracking-radar"
entity.icon = nil
entity.icons = {{
  icon = "__base__/graphics/icons/radar.png",
  tint = util.color "00bfff"
}}
entity.minable.result = "yaiom-fracking-radar"
entity.energy_per_sector = (25000/60*10.25).."MJ"
-- entity.energy_per_sector = (10.25).."MJ"
entity.max_distance_of_sector_revealed = 0
entity.max_distance_of_nearby_sector_revealed = 0
-- entity.energy_per_nearby_scan = "1MJ"
entity.energy_usage = "10.25MW"
entity.pictures.layers[1].tint = util.color "00bfff"
entity.pictures.layers[1].hr_version.tint = util.color "00bfff"

local item = {
  type = "item",
  name = "yaiom-fracking-radar",
  flags = {"goes-to-quickbar"},
  icons = {{
    icon = "__base__/graphics/icons/radar.png",
    tint = util.color "00bfff"
  }},
  icon_size = 32,
  stack_size = 20,
  place_result = "yaiom-fracking-radar",
  subgroup = "extraction-machine", -- ?
  -- subgroup = "defensive-structure",
  order = "z[yaiom]-a[fracking]-b[radar]",
}

local recipe = {
  type = "recipe",
  name = "yaiom-fracking-radar",
  energy_required = 5,
  ingredients = {
    {"radar", 2},
    {"processing-unit", 5},
    {"battery", 10},
    {"steel-plate", 20},
    {"copper-cable", 40},
  },
  result = "yaiom-fracking-radar",
  enabled = false,
  -- order = "z[yaiom]-a[drill]"
}

data:extend{entity, item, recipe}