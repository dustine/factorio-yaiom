local next, scan, chunks, timers, satellites

-- reverse function of f(i) spiral iteration
local function get_spiral_index(x, y)
  local pos = x > -y
  local max = math.max(math.abs(x), math.abs(y))
  local index = pos and 2 * max or 2 * max + 1
  max = pos and max or -max
  index = index * (index - 1)
  if pos then
    index = index - (max - y)
    index = index + (max - x)
  else
    index = index - (max - y)
    index = index + (max - x)
  end
  return index
  --[[
     0, 0 -  0  *
     1, 0 -  1
     1, 1 -  2  *
     0, 1 -  3
    -1, 1 -  4
    -1, 0 -  5
    -1,-1 -  6  *
     0,-1 -  7
     1,-1 -  8
     2,-1 -  9
     2, 0 - 10
     2, 1 - 11
     2, 2 - 12  *
     1, 2 - 13
     0, 2 - 14
    -1, 2 - 15
    -2, 2 - 16
    -2, 1 - 17
    -2, 0 - 18
    -2,-1 - 19
    -2,-2 - 20 *

        - _ + 
    3 2 1 0 1 2 3
          . 
    7 5 3 1 2 4 6
      206 0 212
  ]]
end

local Area = {}

function Area.spiral_iterate(rx, ry)
  local half_x = math.floor(rx / 2)
  local half_y = math.floor(ry / 2)
  local center_x = half_x
  local center_y = half_y

  local x = 0
  local y = 0
  local dx = 0
  local dy = -1
  local iterator = {list = {}, idx = 1}
  for _ = 1, math.max(rx, ry) * math.max(rx, ry) do
    if -(half_x) <= x and x <= half_x and -(half_y) <= y and y <= half_y then
      table.insert(iterator.list, {x, y})
    end
    if x == y or (x < 0 and x == -y) or (x > 0 and x == 1 - y) then
      local temp = dx
      dx = -(dy)
      dy = temp
    end
    x = x + dx
    y = y + dy
  end

  function iterator.iterate()
    if #iterator.list < iterator.idx then
      return
    end
    local x2, y2 = unpack(iterator.list[iterator.idx])
    iterator.idx = iterator.idx + 1

    return (center_x + x2), (center_y + y2)
  end
  return iterator.iterate
end

for x, y in pairs(Area.spiral_iterate(50, 50)) do
  log(get_spiral_index(x, y))
end

local function update_timer(force, tick)
  if not tick then
    local satellites = 

  end
end

script.on_event(
  defines.events.on_chunk_generated,
  function(event)
    local surface = event.surface
    if not (surface and surface.valid) then
      return
    end

    local area = event.area
    local chunk = {
      x = math.floor(area.left_top.x / 32),
      y = math.floor(area.left_top.y / 32)
    }

    -- ready the structure
    local package = {index = get_spiral_index(chunk.x, chunk.y), chunks = {}}
    local new_chunks = package.chunks

    for _, entity in pairs(surface.find_entities_filtered {type = "resource", area = area}) do
      if entity.name:match("^yaiom%-") then
        table.insert(
          new_chunks,
          {
            name = entity.name,
            amount = entity.amount,
            position = entity.positions
          }
        )
        entity.destroy()
      end
    end
    -- shuffle them (looks cooler on reveal)
    for i = #new_chunks, 2 do
      j = math.random(i)
      new_chunks[i], new_chunks[j] = new_chunks[j], new_chunks[i]
    end

    -- index chunks
    chunks[surface.name] = chunks[surface.name] or {}
    local surface_chunks = chunks[surface.name]
    for i = 1, #surface_chunks do
      if surface_chunks[i] < package.index then
        table.insert(surface_chunks, package, i)
        return
      elseif surface_chunks[i] == package.index then
        surface_chunks[i].new_chunks = new_chunks
        return
      end
    end
    table.insert(surface_chunks, package)
  end
)

script.on_event(
  defines.events.on_rocket_launched,
  function(event)
    local rocket = event.rocket
    if not(rocket and rocket.valid and rocket.force) then return end

    local force = rocket.force
    if not satellites[force.name] then
      satellites[force.name] = force.get_item_launched("satellite")
      update_timer(force)
    else
      satellites[force.name] = force.get_item_launched("satellite")
    end
  end
)

script.on_event(
  defines.events.on_research_finished,
  function(event)
    if not event.research.name == "yaiom-hydraulic-fracturing" then
      return
    end

    global.scan = true
    scan = true
    update_timer(event.research.force)
  end
)

script.on_event(
  defines.events.on_tick,
  function(event)
    if not scan then
      return
    end

    if not next or next.tick >= event.tick then
      next = global.next

      local time = 60
      next = {tick = event.tick + time, }
    end
  end
)

--############################################################################--
--                                 INTERFACE                                  --
--############################################################################--

local function on_load()
  scan = global.scan
  next = global.next
  chunks = global.chunks
  timers = global.timers
  satellites = global.satellites
end

script.on_init(
  function()
    global.chunks = {}
    global.timers = {}
    global.satellites = {}

    on_load()
  end
)

script.on_load(on_load)
