require("math")

local Dijkstra = {
   nodes = {},
}

local Node = {}

function Node:new(x, y)
   local node = {
      x = x,
      y = y,
   }

   setmetatable(node, self)
   self.__index = self

   return node
end

Node.__tostring = function(self)
   return self.x .. "," .. self.y
end

Node.__eq = function(a, b)
   return a.x == b.x and a.y == b.y
end

--- Takes a Tiled map file as input, but any matrix with properties.weight should work.
function Dijkstra:init(map, size)
   for y = 1, size do
      for x = 1, size do
         local node = Node:new(x, y)
         self.nodes[node] = map[y][x][1]
      end
   end
end

--- Finds the distance between two tiles in the map
-- @param source A table with x and y
-- @param target A table with x and y
function Dijkstra:calculate(source, target)
   print("Calculating path from " .. source.x .. "," .. source.y .. " to " .. target.x .. "," .. target.y)
   source = Node:new(source.x, source.y)
   target = Node:new(target.x, target.y)

   local function findKey(t, k)
      for key, _ in pairs(t) do
         if key == k then
            return key
         end
      end
   end

   local function setTo(t, k, v)
      local key = findKey(t, k)
      if not key then
         error("Key: " .. tostring(k) .. " not found")
      end
      t[key] = v
   end

   local function shortestDistance(queue, distances)
      local found = nil
      local min = math.huge

      for key, dist in pairs(distances) do
         if queue[key] and dist < min then
            min = dist
            found = key
         end
      end

      if not found then
         error("Shortest distance not found")
      end

      return found
   end

   local function getNeighbors(node, queue)
      local ortho = {
         Node:new(node.x, node.y - 1),
         Node:new(node.x, node.y + 1),
         Node:new(node.x - 1, node.y),
         Node:new(node.x + 1, node.y),
      }

      local neighbors = {}
      for i = 1, 4 do
         if findKey(queue, ortho[i]) then
            table.insert(neighbors, ortho[i])
         end
      end

      return neighbors
   end

   local dist = {}
   local prev = {}
   local queue = {}
   local queueSize = 0

   for k, _ in pairs(self.nodes) do
      dist[k] = math.huge
      prev[k] = nil
      queue[k] = k
      queueSize = queueSize + 1
   end

   setTo(dist, source, 0)

   while queueSize > 0 do
      local u = shortestDistance(queue, dist)

      if u == target then
         local path = {}
         local weight = 0

         if prev[u] or u == source then
            while prev[u] do
               table.insert(path, 1, u)
               weight = weight + dist[u]
               u = prev[u]
            end
         end

         return path, weight
      end

      queue[u] = nil
      queueSize = queueSize - 1

      local neighbors = getNeighbors(u, queue)
      for _, n in pairs(neighbors) do
         local key = findKey(dist, n)
         if not key then
            error("Key: " .. tostring(key) .. " not found")
         end

         local alt = dist[u] + self.nodes[key]
         if alt < dist[key] then
            dist[key] = alt
            prev[key] = u
         end
      end
   end

   error("Path not found")
end

return Dijkstra
