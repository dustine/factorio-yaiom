MOD = {}
MOD.name = "yaiom"
MOD.if_name = "yaiom"
MOD.migrations = {}
MOD.interfaces = {}
MOD.commands = {}

-- local util = require "util"
local chunks, queued, radars, enabled, random

-- local function get_spiral_index(x, y)
--   local pos = x > -y
--   local max = math.max(math.abs(x), math.abs(y))
--   local index = pos and 2 * max or 2 * max + 1
--   return index * (index - 1) + (pos and 1 or -1) * (y - x)
-- end

-- local function get_spiral_coords(i)
--   local n = math.floor(math.sqrt(i) + 0.5)
--   local space = math.abs(n * n - i) - n
--   local dir = (n % 2 == 0 and 0.5) or -0.5
--   return {
--     x = (space + n * n - i - n % 2) * dir,
--     y = (-space + n * n - i - n % 2) * dir
--   }
-- end

local function get_spiral(start_chunk, width)
  local result = {}
  local x = 0
  local y = 0
  local dx = 0
  local dy = -1
  for _ = 1, math.pow(2 * width + 1, 2) do
    table.insert(result, {x = x + start_chunk.x, y = y + start_chunk.y})
    if x == y or (x < 0 and x == -y) or (x > 0 and x == 1 - y) then
      dx, dy = -dy, dx
    end
    x, y = x + dx, y + dy
  end
  return result
end

-- queues a chunk and removes it from the chunks list (chunks requiring regen)
local function scan_chunk(surface, chunk, force)
  if not (surface and surface.valid and chunk) then
    return false
  end
  if not surface.is_chunk_generated(chunk) then
    return false
  end

  local s = surface.name
  local x = chunk.x
  local y = chunk.y
  if not (chunks[s] and chunks[s][x] and chunks[s][x][y]) then
    return false
  end

  table.insert(queued, {surface = surface, chunk = chunk, force = force})
  chunks[s][x][y] = nil
  if not next(chunks[s][x]) then
    chunks[s][x] = nil
  end
  if not next(chunks[s]) then
    chunks[s] = nil
  end
  return true
end

-- scans all chunks, for the impatient player
local function scan_all_chunks()
  for _, surface in pairs(game.surfaces) do
    surface.regenerate_entity("yaiom-ferricupric")
  end
  for _, force in pairs(game.forces) do
    force.rechart()
  end

  global.chunks = {}
  global.random = {}
  chunks = global.chunks
  random = global.random
end

function MOD.commands.yaiom_scan(event)
  local player = game.players[event.player_index]
  if player and player.admin then
    scan_all_chunks()
  end
end

local function save_chunk(s, x, y)
  if not (chunks[s] and chunks[s][x] and chunks[s][x][y]) then
    chunks[s] = chunks[s] or {}
    chunks[s][x] = chunks[s][x] or {}
    chunks[s][x][y] = true
    random[s] = random[s] or {}
    table.insert(random[s], {x = x, y = y})
  end
end

-- delete any originally generating ore, if that mechanic is active
local function on_chunk_generated(event)
  if not enabled then
    return
  end

  local surface = event.surface
  if not (surface and surface.valid) then
    return
  end

  local area = event.area

  local x = math.floor(area.left_top.x / 32)
  local y = math.floor(area.left_top.y / 32)
  area.left_top.x = area.left_top.x + 0.5
  area.left_top.y = area.left_top.y + 0.5
  area.right_bottom.x = area.right_bottom.x - 0.5
  area.right_bottom.y = area.right_bottom.y - 0.5

  for _, entity in pairs(
    surface.find_entities_filtered {
      name = "yaiom-ferricupric",
      area = area
    }
  ) do
    if entity.valid then
      entity.destroy()
    end
  end

  save_chunk(surface.name, x, y)
end

-- on sector scanned with our dummy radars
-- pick a target chunk, scan it, remove from queue(s)
local function on_sector_scanned(event)
  if not enabled then
    return
  end

  local radar = event.radar
  if not (radar and radar.valid) then
    return
  end

  local surface = radar.surface
  local force = radar.force
  if not (surface and surface.valid and force and force.valid) then
    return
  end

  if radar.name == "yaiom-fracking-radar" then
    local id = radar.unit_number
    local targets = radars[id]
    if not targets then
      radars[id] = get_spiral(event.chunk_position, 3)
      targets = radars[id]
    end

    for c, chunk in pairs(targets) do
      targets[c] = nil
      if scan_chunk(surface, chunk, force) then
        return
      end
    end

    radars[id] = nil
    radar.order_deconstruction(force)
  elseif radar.name == "yaiom-fracking-beacon" then
    local s = surface.name
    random[s] = random[s] or {}
    local targets = random[s]
    if not (next(targets)) then
      return
    end

    -- balance, make the satellites be on a logarithmic scale
    local satellites = force.get_item_launched("satellite") or 0
    if satellites < 1 then
      return
    end
    satellites = math.ceil(math.log(satellites) / math.log(2))
    if satellites < 1 then
      satellites = 1
    end

    for i = #targets, 1, -1 do
      -- Fisher-Yates for a random pick...
      local j = math.random(i)
      targets[i], targets[j] = targets[j], targets[i]

      -- but then treat it as a target chunk
      -- remove if visible and scan it
      local chunk = targets[i]
      if force.is_chunk_charted(surface, chunk) then
        table.remove(targets, i)
        if scan_chunk(surface, chunk, force) then
          satellites = satellites - 1
          if satellites < 1 then
            return
          end
        end
      end
    end
  end
end

-- blow up extraneous beacons (balance reasons + looks cool)
local function on_build_entity(event)
  local entity = event.created_entity
  if not (entity and entity.valid and entity.name == "yaiom-fracking-beacon") then
    return
  end

  local surface = entity.surface
  local force = entity.force
  if not (surface and surface.valid and force and force.valid) then
    return
  end
  for _, beacon in pairs(
    surface.find_entities_filtered {
      name = "yaiom-fracking-beacon",
      force = force
    }
  ) do
    if beacon.valid and beacon ~= entity then
      beacon.die() -- yes, die, I want the alert and the bang
    end
  end
end

-- chunk regen smoothing function
local function on_tick(event)
  -- TODO: make this a setting?
  -- TODO: make this dynamic (depending on queue size?)?
  if not (enabled and event.tick % 20 == 0) then
    return
  end

  local id, target = next(queued)
  if not id then
    return
  end
  queued[id] = nil

  local surface = target.surface
  if not surface.valid then
    return
  end
  local chunk = target.chunk
  local force = target.force
  if not force.valid then
    return
  end

  surface.regenerate_entity({"yaiom-ferricupric"}, {chunk})
  if force and force.valid then
    force.chart(
      surface,
      {
        left_top = {
          x = chunk.x * 32 + 16,
          y = chunk.y * 32 + 16
        },
        right_bottom = {
          x = chunk.x * 32 + 16,
          y = chunk.y * 32 + 16
        }
      }
    )
  end
end

script.on_event(defines.events.on_chunk_generated, on_chunk_generated)
script.on_event(defines.events.on_sector_scanned, on_sector_scanned)
script.on_event(defines.events.on_robot_built_entity, on_build_entity)
script.on_event(defines.events.on_built_entity, on_build_entity)
script.on_event(defines.events.on_tick, on_tick)

--############################################################################--
--                                 INTERFACE                                  --
--############################################################################--

local function reload_settings()
  local prev = global.enabled
  global.enabled = not settings.global["yaiom-reveal-all"].value

  if prev and not global.enabled then
    -- turned it off
    scan_all_chunks()
  end
end

local function on_load()
  chunks = global.chunks
  queued = global.queued
  radars = global.radars
  random = global.random
  enabled = global.enabled
end

local function on_init()
  global.chunks = {}
  global.queued = {}
  global.radars = {}
  global.random = {}

  reload_settings()
  on_load()

  if enabled then
    for s, surface in pairs(game.surfaces) do
      for chunk in surface.get_chunks() do
        save_chunk(s, chunk.x, chunk.y)
      end
    end
  else
    scan_all_chunks()
  end

  global._changed = {}
  for ver, _ in pairs(MOD.migrations) do
    global._changed[ver] = true
  end
end

script.on_init(on_init)
script.on_load(on_load)

local function on_runtime_mod_setting_changed(event)
  if event.setting:match("^" .. MOD.if_name) then
    reload_settings()
    on_load()
  end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)

remote.add_interface(MOD.if_name, MOD.interfaces)
for name, command in pairs(MOD.commands) do
  commands.add_command(name, {"command-help." .. name}, command)
end

--------------------------------------------------------------------------------
--                                 MIGRATION                                  --
--------------------------------------------------------------------------------

-- added random table, for satellite scanning
MOD.migrations["1.0.0"] = function()
  global.random = {}
  local r = global.random
  for surface, sc in pairs(chunks) do
    r[surface] = {}
    local rs = r[surface]
    for x, xc in pairs(sc) do
      for y, _ in pairs(xc) do
        table.insert(rs, {x = x, y = y})
      end
    end
  end

  return true
end

local function on_configuration_changed(event)
  if event.mod_changes[MOD.name] then
    if not global._changed then
      global._changed = {}
    end
    for ver, migration in pairs(MOD.migrations) do
      if not global._changed[ver] then
        if migration(event) then
          global._changed[ver] = true
          log("Ran migration for " .. ver)
        else
          log("Failed migration for " .. ver)
        end
      end
    end
  end

  reload_settings()
  on_load()
end

script.on_configuration_changed(on_configuration_changed)
