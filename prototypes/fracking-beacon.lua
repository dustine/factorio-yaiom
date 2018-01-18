local entity = table.deepcopy(data.raw.radar.radar)
entity.name = "yaiom-fracking-beacon"
entity.icon = nil
entity.icons = {
  {
    icon = "__base__/graphics/icons/small-lamp.png",
    tint = util.color "00bfff"
  }
}
entity.corpse = "small-remnants"
entity.dying_explosion = "medium-explosion"
entity.collision_box = {{-0.4, -0.4}, {0.4, 0.4}}
entity.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
entity.drawing_box = {{-0.5, -1.5}, {0.5, 0.5}}
entity.minable.result = "yaiom-fracking-beacon"
-- entity.energy_per_sector = "125MJ"
entity.energy_per_sector = "5kJ"
entity.max_distance_of_sector_revealed = 0
entity.max_distance_of_nearby_sector_revealed = 0
-- entity.energy_per_nearby_scan = "1kJ"
entity.energy_usage = "5kW"
-- log(serpent.block(entity.pictures))
entity.integration_patch = nil
entity.pictures = {
  layers = {
    {
      filename = "__yaiom__/graphics/fracking/beacon.png",
      priority = "low",
      width = 384 / 4,
      height = 512 / 4,
      line_length = 4,
      -- frame_count = 16,
      direction_count = 16,
      -- direction_count = 1,
      -- repeat_count = 64,
      -- line_length = 1,
      shift = util.by_pixel(0, -16)
    }
  }
}
-- entity.pictures.layers[1].tint = util.color "00bfff"
-- entity.pictures.layers[1].hr_version.tint = util.color "00bfff"

local item = {
  type = "item",
  name = "yaiom-fracking-beacon",
  flags = {"goes-to-quickbar"},
  icons = {
    {
      icon = "__base__/graphics/icons/small-lamp.png",
      tint = util.color "00bfff"
    }
  },
  icon_size = 32,
  stack_size = 1,
  place_result = "yaiom-fracking-beacon",
  subgroup = "extraction-machine", -- ?
  -- subgroup = "defensive-structure",
  order = "z[yaiom]-a[fracking]-c[beacon]"
}

local recipe = {
  type = "recipe",
  name = "yaiom-fracking-beacon",
  energy_required = 60,
  ingredients = {
    {"small-lamp", 1}
  },
  result = "yaiom-fracking-beacon",
  enabled = false
  -- order = "z[yaiom]-a[drill]"
}

data:extend {entity, item, recipe}
