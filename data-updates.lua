local presets = data.raw["map-gen-presets"].default

presets["rich-resources"].basic_settings.autoplace_controls["yaiom-orichalcum"] = { richness = "very-good"}
presets["rail-world"].basic_settings.autoplace_controls["yaiom-orichalcum"] = {
  frequency = "very-low",
  size = "high"
}

-- local Entity = require "stdlib.data.entity"
-- local Recipe = require "stdlib.data.recipe"
-- local Technology = require "stdlib.data.technology"

if angelsmods and angelsmods.refining then
  -- pick a teal green so to avoid confusing with the blue ores of angel's
  data.raw.resource["yaiom-orichalcum"].map_color = util.color "00FF7F"

  -- tier 0
  local degassing = data.raw.recipe["yaiom-orichalcum-cleaning"]
  degassing.icon = "__yaiom__/graphics/orichalcum/recipe-degas.png"
  degassing.localised_name = {"recipe-name.yaiom-orichalcum-degassing"}
  degassing.ingredients = {
    {type = "fluid", name = "water", amount = 100},
    {type = "fluid", name = "yaiom-orichalcum-fluid", amount = 30}
  }
  degassing.results = {
    {type = "fluid", name = "petroleum-gas", amount = 20},
    {type = "fluid", name = "mineral-sludge", amount = 100}
  }
  local filtering = data.raw.recipe["yaiom-orichalcum-filtration"]
  filtering.category = "filtering"
  filtering.subgroup = "filtering"
  table.insert(filtering.ingredients, {type = "fluid", name = "water-purified", amount = 50})
  table.insert(filtering.ingredients, {type = "item", name = "filter-coal", amount = 1})
  -- table.insert(filtering.results, {type = "fluid", name = "water-mineralized", amount = 30})
  table.insert(filtering.results, {type="item", name="filter-frame", amount=1})

  table.insert(data.raw.technology["yaiom-orichalcum"].effects, {
    type = "unlock-recipe",
    recipe = "yaiom-orichalcum-filtration"
  })

  -- tier 1
  local dust = data.raw.item["yaiom-orichalcum"]
  -- degassing.icon = "__yaiom__/graphics/orichalcum/dust.png"
  dust.localised_name = {"item-name.yaiom-orichalcum-dust"}
  -- TODO: right category

  local process = data.raw.recipe["yaiom-orichalcum-processing"]
  process.category = "water-treatment"
  process.subgroup = "water-treatment"
  process.ingredients = {
    {type = "fluid", name = "yaiom-orichalcum-sludge", amount = 100}
  }
  table.insert(process.results, {type = "fluid", name = "water-purified", amount = 50})

else
  -- pass
end