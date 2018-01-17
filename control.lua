MOD = {}
MOD.name = "yaiom"
MOD.if_name = "yaiom"
MOD.migrations = {}
MOD.interfaces = {}
MOD.commands = {}

-- local util = require "util"
local chunks, queued, radars, enabled

local function get_spiral(start_chunk, width)
  local result = {}
  local x = 0
  local y = 0
  local dx = 0
  local dy = -1
  for i=1, math.pow(2*(width+1), 2) do
    table.insert(result, {x = x + start_chunk.x, y = y + start_chunk.y})
    if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y) then
      dx, dy = -dy, dx
    end
    x, y = x + dx, y + dy
  end
  return result
end

local function scan_chunk(surface, chunk, force)
  if not(surface and surface.valid and chunk) then return false end
  if not surface.is_chunk_generated(chunk) then return false end

  local s = surface.name
  local x = chunk.x
  local y = chunk.y
  if not(chunks[s] and chunks[s][x] and chunks[s][x][y]) then return false end

  table.insert(queued, {surface = surface, chunk = chunk, force = force})
  chunks[s][x][y] = nil
  if not next(chunks[s][x]) then chunks[s][x] = nil end
  if not next(chunks[s]) then chunks[s] = nil end
  return true
end

local function scan_all_chunks()
  for _, surface in pairs(game.surfaces) do
    surface.regenerate_entity("yaiom-ferricupric")
  end
  for _, force in pairs(game.forces) do
    force.rechart()
  end

  global.chunks = {}
  chunks = global.chunks
end

function MOD.commands.yaiom_scan(event)
  local player = game.players[event.player_index]
  if player and player.admin then scan_all_chunks(player.force) end
end



local function on_chunk_generated(event)
  if not enabled then return end

  local surface = event.surface
  if not (surface and surface.valid) then return end

  local area = event.area

  local x = math.floor(area.left_top.x / 32)
  local y = math.floor(area.left_top.y / 32)
  area.left_top.x = area.left_top.x + 0.5
  area.left_top.y = area.left_top.y + 0.5
  area.right_bottom.x = area.right_bottom.x - 0.5
  area.right_bottom.y = area.right_bottom.y - 0.5

  for _, entity in pairs(surface.find_entities_filtered{
    name = "yaiom-ferricupric", area = area
  }) do
    if entity.valid then entity.destroy() end
  end

  local s = surface.name
  chunks[s] = chunks[s] or {}
  chunks[s][x] = chunks[s][x] or {}
  chunks[s][x][y] = true
end

local function on_sector_scanned(event)
  if not enabled then return end

  local radar = event.radar
  if not(radar and radar.valid and radar.name == "yaiom-fracking-radar") then return end

  local id = radar.unit_number
  local targets = radars[id]
  if not targets then
    log("generated")
    radars[id] = get_spiral(event.chunk_position, 3)
    targets = radars[id]
  end

  local surface = radar.surface
  local force = radar.force
  for c, chunk in pairs(targets) do
    targets[c] = nil
    if scan_chunk(surface, chunk, force) then return end
  end

  radars[id] = nil
  radar.order_deconstruction(force)
end

local function on_tick(event)
  if not(enabled and event.tick%6 == 0) then return end

  local id, target = next(queued)
  if not id then return end
  queued[id] = nil

  local surface = target.surface
  if not surface.valid then return end
  local chunk = target.chunk
  local force = target.force

  surface.regenerate_entity("yaiom-ferricupric", {chunk})
  if force and force.valid then
    force.chart(surface, {
      left_top = {
        x = chunk.x*32+16,
        y = chunk.y*32+16
      },
      right_bottom = {
        x = chunk.x*32+16,
        y = chunk.y*32+16
      }
    })
  end

end

script.on_event(defines.events.on_chunk_generated, on_chunk_generated)
script.on_event(defines.events.on_sector_scanned, on_sector_scanned)
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
  enabled = global.enabled
end

local function on_init()
  global._changed = {}
  global.chunks = {}
  global.queued = {}
  global.radars = {}

  reload_settings()
  on_load()

  for ver, _ in pairs(MOD.migrations) do
    global._changed[ver] = true
  end
end

script.on_init(on_init)
script.on_load(on_load)

local function on_runtime_mod_setting_changed(event)
  if event.setting:match("^"..MOD.if_name) then
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

local function on_configuration_changed(event)
  if event.mod_changes[MOD.name] then
    if not global._changed then
      global._changed = {}
    end
    for ver, migration in pairs(MOD.migrations) do
      if not global._changed[ver] and migration(event) then
        global._changed[ver] = true
      end
    end
  end

  reload_settings()
  on_load()
end

script.on_configuration_changed(on_configuration_changed)
