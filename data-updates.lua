local presets = data.raw["map-gen-presets"].default

presets["rich-resources"].basic_settings.autoplace_controls["yaiom-orichalcum"] = { richness = "very-good"}
presets["rail-world"].basic_settings.autoplace_controls["yaiom-orichalcum"] = {
  frequency = "very-low",
  size = "high"
}

local Data = require "stdlib.data.data"
local Item = require "stdlib.data.item"
local Entity = require "stdlib.data.entity"
local Recipe = require "stdlib.data.recipe"
local Technology = require "stdlib.data.technology"

local function make_recipe_production_enabled(recipe)
  for _, module in pairs({"productivity-module", "productivity-module-2", "productivity-module-3"}) do
    table.insert(data.raw.module[module].limitation, recipe)
  end
end

local function finish_sorting_recipe(name, results, subgroup, icon_product, icon_result, icon_result_behind)
  local icon = {{
    icon = "__angelsrefining__/graphics/icons/sort-icon.png",
  }}
  local recipe = Recipe(name)
    :change_category("ore-sorting")
    :subgroup_order(subgroup)
    :set_fields({
      results = {}
    })
    :replace_icon(icon, 32)
  if icon_product then
    table.insert(icon, {
      icon = icon_product,
      shift = {-8,8},
      scale = 0.5,
    })
  end
  if icon_result_behind then
    table.insert(icon, {
      icon = icon_result_behind,
      shift = {8,4},
      scale = 0.5,
    })
  end
  if icon_result then
    table.insert(icon, {
      icon = icon_result,
      shift = {8,8},
      scale = 0.5,
    })
  end
  for _, result in pairs(results) do
    table.insert(recipe.results, result)
  end
  return recipe
end

if angelsmods and angelsmods.refining then
  -- pick a teal green so to avoid confusing with the blue ores of angel's
  Entity("yaiom-orichalcum", "resource")
    :set_fields({
      map_color = util.color "00FF7F"
    })

  Data.extend_array({{
    type = "item-subgroup",
    name = "yaiom-sorting",
    group = "resource-refining",
    order = "j-z[yaiom]-b[orichalcum]"
  }})

  --##########################################################################--
  --                                  TIER 0                                  --
  --##########################################################################--

  local filtering = Recipe("yaiom-orichalcum-filtration")
    :change_category("filtering")
    :add_ingredient({type = "fluid", name = "water-purified", amount = 50})
    :add_ingredient({type = "item", name = "filter-coal", amount = 1})
    :set_fields({
      subgroup = "filtering"
    })
    :replace_icon({{
      icon = "__angelsrefining__/graphics/icons/filter-coal.png",
    },{
      icon = "__yaiom__/graphics/orichalcum/sludge.png",
      shift = {10,8},
      scale = 0.6,
    }}, 32)
  table.insert(filtering.results, {type="item", name="filter-frame", amount=1})

  Recipe("yaiom-orichalcum-cleaning")
    :change_category("liquifying")
    :subgroup_order("liquifying", "z[yaiom]-b[orichalcum]-0-b[degassing]")
    :set_fields({
      localised_name = {"recipe-name.yaiom-orichalcum-degassing"},
      ingredients = {
        {type = "fluid", name = "yaiom-orichalcum-sludge", amount = 30}
      },
      results = {
        {type = "fluid", name = "petroleum-gas", amount = 20},
        {type = "item", name = "slag", amount = 10}
      },
    })
    :replace_icon("__yaiom__/graphics/orichalcum/recipe-degas.png", 32)

  local technology_0 = Technology("yaiom-orichalcum")
    :remove_pack("production-science-pack")
    :remove_prereq("advanced-material-processing-2")
    :add_prereq("slag-processing-1")
    :add_effect("yaiom-orichalcum-filtration")
  technology_0.effects[2], technology_0.effects[3] = technology_0.effects[3], technology_0.effects[2]

  --##########################################################################--
  --                                  TIER 1                                  --
  --##########################################################################--

  -- degassing.icon = "__yaiom__/graphics/orichalcum/dust.png"
  local dust = Item("yaiom-orichalcum")
    -- TODO: right category
    :subgroup_order(nil, "z[yaiom]-b[orichalcum]-1-a[dust]")
    :set_fields({
      localised_name = {"item-name.yaiom-orichalcum-dust"}
    })

  local process = Recipe("yaiom-orichalcum-processing")
    :change_category("water-treatment")
    :subgroup_order("water-cleaning", "z[yaiom]-b[orichalcum]-1-a[processing]")
    :remove_ingredient("water")
    :replace_ingredient("yaiom-orichalcum-fluid", "yaiom-orichalcum-sludge")
    :set_fields({
      localised_name = {"recipe-name.yaiom-orichalcum-dust"},
      energy_required = 3,
    })
    :replace_icon({{
      icon = "__yaiom__/graphics/orichalcum/sludge.png",
      shift = {0,-4},
      scale = 0.75
    },{
      icon = "__base__/graphics/icons/fluid/light-oil.png",
      shift = {-11,11},
      scale = 0.25
    },{
      icon = dust.icon,
      shift = {0,12},
      scale = 0.20
    },{
      icon = "__base__/graphics/icons/coal.png",
      dark_background_icon = "__base__/graphics/icons/coal-dark-background.png",
      shift = {12,12},
      scale = 0.20
    }}, 32)
  process.main_product = "yaiom-orichalcum"
  table.insert(process.results, {type = "fluid", name = "water-purified", amount = 50})

  finish_sorting_recipe("yaiom-orichalcum-dust-sorting", {{"angels-ore1-crushed", 1}, {"angels-ore3-crushed", 1}, {"slag", 1}}, "yaiom-sorting", dust.icon)
    :set_fields({
      localised_name = {"recipe-name.yaiom-sorting-2", dust.localised_name, {"entity-name.angels-ore1"}, {"entity-name.angels-ore3"}}
    })

  Recipe("yaiom-orichalcum-iron")
    :remove_unlock("yaiom-advanced-orichalcum-1")

  Recipe("yaiom-orichalcum-copper")
    :remove_unlock("yaiom-advanced-orichalcum-1")

  Technology("yaiom-advanced-orichalcum-1")
    :remove_pack("high-tech-science-pack")
    :remove_prereq("nuclear-fuel-reprocessing")
    :add_prereq("advanced-material-processing-2")
    :add_prereq("water-treatment-2")
    :add_effect("yaiom-orichalcum-dust-sorting")
    :set_fields({count = 1000})

  --##########################################################################--
  --                                  TIER 2                                  --
  --##########################################################################--

  local ore1_icon = Data.get_icon_from("item", "angels-ore1-crushed")
  local ore2_icon = Data.get_icon_from("item", "angels-ore2-crushed")
  local ore3_icon = Data.get_icon_from("item", "angels-ore3-crushed")
  local ore4_icon = Data.get_icon_from("item", "angels-ore4-crushed")

  local irradiated = Item("yaiom-irradiated-orichalcum")
    :remove_flag("hidden")
    :subgroup_order()

  local irradiated_name = {"item-name.yaiom-irradiated-orichalcum"}

  finish_sorting_recipe("yaiom-orichalcum-ore-sorting-0-1", {{"angels-ore2-crushed", 2}, {"angels-ore4-crushed", 2}}, "yaiom-sorting", irradiated.icon, ore2_icon, ore4_icon)
    :set_fields({
      localised_name = {"recipe-name.yaiom-sorting-2", irradiated_name, {"entity-name.angels-ore2"}, {"entity-name.angels-ore4"}}
    })

  finish_sorting_recipe("yaiom-orichalcum-ore-sorting-1-1", {{"angels-ore1-crushed", 4}, {"angels-ore4-crushed", 1}}, "yaiom-sorting", irradiated.icon, ore1_icon, ore4_icon)
    :add_ingredient("catalysator-brown")
    :set_fields({
      localised_name = {"recipe-name.yaiom-sorting-2", irradiated_name, {"entity-name.angels-ore1"}, {"entity-name.angels-ore4"}}
    })

  finish_sorting_recipe("yaiom-orichalcum-ore-sorting-1-2", {{"angels-ore3-crushed", 4}, {"angels-ore2-crushed", 1}}, "yaiom-sorting", irradiated.icon, ore3_icon, ore2_icon)
    :add_ingredient("catalysator-brown")
    :set_fields({
      localised_name = {"recipe-name.yaiom-sorting-2", irradiated_name, {"entity-name.angels-ore3"}, {"entity-name.angels-ore2"}}
    })

  Technology("yaiom-advanced-orichalcum-2")
    :set_fields({enabled = true,})

  make_recipe_production_enabled("yaiom-orichalcum-cleaning")
  make_recipe_production_enabled("yaiom-orichalcum-processing")
else
  for technology in pairs(data.raw.technology) do
    Recipe("fill-yaiom-orichalcum-sludge-barrel")
      :remove_unlock()
    Recipe("empty-yaiom-orichalcum-sludge-barrel")
      :remove_unlock()
  end

  make_recipe_production_enabled("yaiom-orichalcum-cleaning")
  make_recipe_production_enabled("yaiom-orichalcum-processing")
end