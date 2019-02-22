local CelAutMap = Class:extend()

function CelAutMap:new(params)
    self.seed = 0
    love.math.setRandomSeed(self.seed)
    self.cellSize = params.cellSize or 5
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.smoothingIterations = params.smoothingIterations or 5
    self.fillPercentage = params.fillPercentage or 0.47

    self:createGrid()
    self:initialiseGridValues()
    for i = 0, self.smoothingIterations do
        self:smoothGrid()
    end
    self:processMap()
end

function CelAutMap:createGrid()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
        end
    end
end

function CelAutMap:initialiseGridValues()
    local mapBorderThickness = self.mapBorderThickness or 0

    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if love.math.random() > self.fillPercentage then
                self[x][y] = 1
            else
                self[x][y] = 0
            end

            if x <= mapBorderThickness or x > self.xSize - mapBorderThickness then
                self[x][y] = 0
            end

            if y <= mapBorderThickness or y > self.ySize - mapBorderThickness then
                self[x][y] = 0
            end

        end
    end
end

function CelAutMap:smoothGrid()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            local neighbourCount = 0
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if not (dx == 0 and dy == 0) and self[x + dx] and self[x + dx][y + dy] == 0 then
                        neighbourCount = neighbourCount + 1
                    end

                    if self[x + dx] == nil then
                        neighbourCount = neighbourCount + 1
                    elseif self[x + dx][y + dy] == nil then
                        neighbourCount = neighbourCount + 1
                    end
                end
            end

            if neighbourCount > 4 then
                self[x][y] = 0
            elseif neighbourCount < 4 then
                self[x][y] = 1
            end
        end
    end
end

function CelAutMap:getRegionTiles(coord)
    local tiles = {}
    local mapFlags = {}
    local tileType = self[coord.x][coord.y]
    local queue = {}

    for x = 1, self.xSize do
        mapFlags[x] = {}
        for y = 1, self.ySize do
            mapFlags[x][y] = 0
        end
    end

    mapFlags[coord.x][coord.y] = 1
    table.insert(queue, coord)

    while #queue > 0 do
        local tile = table.remove(queue)
        table.insert(tiles, tile)

        for x = tile.x - 1, tile.x + 1 do
            for y = tile.y - 1, tile.y + 1 do
                if self:isInBounds(x, y) and (x == tile.x or y == tile.y) then
                    if mapFlags[x][y] ~= 1 and self[x][y] == tileType then
                        mapFlags[x][y] = 1
                        table.insert(queue, { x = x, y = y })
                    end
                end
            end
        end
    end

    return tiles
end

function CelAutMap:getRegionsOfType(tileType)
    local regions = {}
    local mapFlags = {}
    for x = 1, self.xSize do
        mapFlags[x] = {}
        for y = 1, self.ySize do
            mapFlags[x][y] = 0
        end
    end

    local regionCount = 1
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if mapFlags[x][y] ~= 1 and self[x][y] == tileType then
                local newRegion = self:getRegionTiles({ x = x, y = y })
                io.write(#newRegion .. '\n')
                table.insert(regions, newRegion)
                -- io.write('Found region number ' .. regionCount .. '\n')
                regionCount = regionCount + 1
                -- io.write('New region covers tiles: ' .. '\n')
                for k, v in pairs(newRegion) do
                    mapFlags[v.x][v.y] = 1
                    -- io.write('x: ' .. v.x .. ' y: ' .. v.y .. '\n')
                end
            end
        end
    end

    io.write('Found ' .. #regions .. ' regions of type ' .. tileType .. '\n')

    return regions
end

function CelAutMap:processMap()
    io.write('Removing small wall regions\n')
    local wallRegions = self:getRegionsOfType(0)
    local wallMinSizeThreshold = 0
    
    for k, wallRegion in pairs(wallRegions) do
        if #wallRegion < wallMinSizeThreshold then
            for j, tile in pairs(wallRegion) do
                self[tile.x][tile.y] = 1
            end
        end
    end

    -- local wallCount = 0
    -- for x = 1, self.xSize do
    --     for y = 1, self.ySize do
    --         if self[x][y] == 0 then
    --             wallCount = wallCount + 1
    --         end
    --     end
    -- end
    -- io.write('Map contains ' .. wallCount .. ' wall tiles\n')

    io.write('Removing small floor regions\n')
    local openRegions = self:getRegionsOfType(1)
    -- TODO: If this value is smaller than mapScale^2, we will have a floor tile in the bottom right hand corner
    local openMinSizeThreshold = 0
    local survivingOpenRegions = {}

    for k, openRegion in pairs(openRegions) do
        if #openRegion < openMinSizeThreshold then
            for j, tile in pairs(openRegion) do
                self[tile.x][tile.y] = 1
            end
        else
            table.insert(survivingOpenRegions, CelAutRegion{
                tiles = openRegion,
                map = self
            })
        end
    end

    io.write('Sorting surviving open regions by size\n')
    table.sort(survivingOpenRegions, 
        function(a, b)
            return #a.tiles > #b.tiles
        end
    )

    survivingOpenRegions[1].isMainRegion = true
    survivingOpenRegions[1].isAccessibleFromMainRegion = true

    io.write('Connecting regions\n')
    self:connectClosestRegions(survivingOpenRegions, false)
end

function CelAutMap:isInBounds(x, y)
    return x > 0 and x < self.xSize and y > 0 and y < self.ySize
end

function CelAutMap:keypressed(key)
    self:smoothGrid()
end

return CelAutMap
