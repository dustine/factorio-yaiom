MOD = {}
MOD.name = "yaiom"
MOD.if_name = "yaiom"
MOD.interfaces = {}
MOD.commands = {}

local util = require "util"

local next, active, chunks, enabled, timers, satellites

-- reverse function of f(i) spiral iteration
local function get_spiral_index(x, y)
  local pos = x > -y
  local max = math.max(math.abs(x), math.abs(y))
  local index = pos and 2 * max or 2 * max + 1
  return index * (index - 1) + (pos and 1 or -1) * (y - x)
end

local function update_timer(force, tick, override)
  local surface = game.surfaces.nauvis
  local eyes = satellites[force.name]
  if not override and not (eyes and eyes > 0) then
    return
  end
  if not tick then
    -- tick = 500 * 60 * math.floor(math.log(satellites[force.name]+1)/math.log(2))
    -- log(surface.ticks_per_day)
    tick = math.floor(surface.ticks_per_day / math.log(eyes + 1) * math.log(2))
    -- log(tick)
    tick = game.tick + tick
  -- log(tick)
  end

  while timers[tick] do
    tick = tick + 1
  end
  timers[tick] = force
  next = next.tick < tick and next or {tick = tick, force = force}
  global.next = next
end

function MOD.commands.yaiom_scan(event)
  local player = game.players[event.player_index]
  local number = tonumber(event.parameter) or 1
  if player and player.admin then
    for i = 1, number do
      update_timer(player.force, 0, true)
    end
  end
end

script.on_event(
  defines.events.on_chunk_generated,
  function(event)
    local surface = event.surface
    if not (enabled and surface and surface.valid and surface.name == "nauvis") then
      return
    end

    local area = event.area
    local coords = {
      x = math.floor(area.left_top.x / 32),
      y = math.floor(area.left_top.y / 32)
    }
    area.left_top.x = area.left_top.x + 0.5
    area.left_top.y = area.left_top.y + 0.5
    area.right_bottom.x = area.right_bottom.x - 0.5
    area.right_bottom.y = area.right_bottom.y - 0.5
    local center = {
      x = math.floor(area.left_top.x + (area.right_bottom.x - area.left_top.x) / 2),
      y = math.floor(area.left_top.y + (area.right_bottom.y - area.left_top.y) / 2)
    }

    -- ready the structure
    local chunk = {
      center = center,
      area = area,
      coords = coords,
      index = get_spiral_index(coords.x, coords.y)
    }

    for _, entity in pairs(surface.find_entities_filtered {name = "yaiom-ferricupric", area = area}) do
      if entity.valid then
        entity.destroy()
      end
    end
    -- -- shuffle them (looks cooler on reveal)
    -- for i = #new_chunks, 2 do
    --   j = math.random(i)
    --   new_chunks[i], new_chunks[j] = new_chunks[j], new_chunks[i]
    -- end

    -- index chunks
    for i = 1, #chunks do
      if chunks[i].index < chunk.index then
        table.insert(chunks, i, chunk)
        return
      elseif chunks[i].index == chunk.index then
        return
      end
    end
    table.insert(chunks, chunk)
  end
)

script.on_event(
  defines.events.on_rocket_launched,
  function(event)
    local rocket = event.rocket
    if not (rocket and rocket.valid and rocket.force) then
      return
    end

    local force = rocket.force
    local name = force.name

    local prev = satellites[name]
    satellites[name] = force.get_item_launched("satellite")
    if active and enabled and (not prev or prev < 1) and satellites[name] and satellites[name] >= 1 then
      update_timer(force, 0)
    end
  end
)

script.on_event(
  defines.events.on_research_finished,
  function(event)
    if not(event.research and event.research.valid and event.research.name == "yaiom-hydraulic-fracturing") then
      return
    end

    active = true
    global.active = active
    update_timer(event.research.force, 0)
  end
)

local function update_next()
  local tick = math.huge
  for t, f in pairs(timers) do
    if f and f.valid and tick > t then
      tick = t
    elseif not (f and f.valid) then
      timers[t] = nil
    end
  end
  next = {tick = tick, force = timers[tick] or nil}
  global.next = next
end

script.on_event(
  defines.events.on_tick,
  function(event)
    if not (active and enabled) then
      return
    end

    if not next then
      update_next()
    end
    if next.tick <= event.tick then
      local force = next.force
      if force and force.valid then
        local surface = game.surfaces.nauvis

        for i = #chunks, 1, -1 do
          local chunk = chunks[i]
          if force.is_chunk_charted(surface, chunk.coords) then
            surface.regenerate_entity({"yaiom-ferricupric"}, {chunk.coords})
            force.chart(surface, chunk.area)
            local count = surface.count_entities_filtered({name = "yaiom-ferricupric", area = chunk.area})
            if count > 0 then
              game.print("Scan finished, found ore!", util.color("00ccff"))
            -- else
            -- game.print("active finished.")
            end
            -- log("Scan finished.")
            table.remove(chunks, i)
            break
          end
        end
        timers[next.tick] = nil
        update_timer(force)
      else
        -- log("expunge")
        timers[next.tick] = nil
      end

      update_next()
    end
  end
)

--############################################################################--
--                                 INTERFACE                                  --
--############################################################################--

local function reload_settings()
  local prev = global.enabled
  global.enabled = not settings.global["yaiom-reveal-all"].value

  if prev and not global.enabled and prev ~= global.enabled then
    -- turned it off
    game.surfaces.nauvis.regenerate_entity({"yaiom-ferricupric"})
    for _, force in pairs(game.forces) do
      force.rechart()
    end
    global.chunks = {}
    chunks = global.chunks
  end
end

local function on_load()
  next = global.next
  active = global.active
  chunks = global.chunks
  timers = global.timers
  enabled = global.enabled
  satellites = global.satellites
end

script.on_init(
  function()
    global.chunks = {}
    global.timers = {}
    global.satellites = {}

    reload_settings()
    on_load()
  end
)

script.on_load(on_load)

script.on_event(
  defines.events.on_runtime_mod_setting_changed,
  function(event)
    if event.setting == "yaiom-reveal-all" then
      reload_settings()
      on_load()
    end
  end
)

remote.add_interface(MOD.if_name, MOD.interfaces)
for name, command in pairs(MOD.commands) do
  commands.add_command(name, {"command-help." .. name}, command)
end

--------------------------------------------------------------------------------
--                                 MIGRATION                                  --
--------------------------------------------------------------------------------

MOD.migrations = {}

script.on_configuration_changed(
  function(event)
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
)
