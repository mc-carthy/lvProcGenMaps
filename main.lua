require('src.utils.dependencies')

local grid

function love.load()
    -- grid = generateCelAutGrid()
    grid = generatePerlinGrid()
end

function love.update(dt)
end

function love.draw()
    for x = 1, grid.xSize do
        for y = 1, grid.ySize do
            local c = grid[x][y]
            love.graphics.setColor(c, c, c)
            love.graphics.rectangle('fill', (x - 1) * grid.cellSize, (y - 1) * grid.cellSize, grid.cellSize, grid.cellSize)
        end
    end


    -- TODO: Extract this to celAut class
    -- for x = 1, grid.xSize do
    --     for y = 1, grid.ySize do
    --         if grid[x][y] == 0 then
    --             love.graphics.setColor(0.25, 0.25, 0.25)
    --         elseif grid[x][y] == 1 then
    --             love.graphics.setColor(1, 0.75, 0.25)
    --         else
    --             love.graphics.setColor(1, 0, 1)
    --         end
    --         -- love.graphics.setColor(grid[x][y], grid[x][y], grid[x][y])
    --         love.graphics.rectangle('fill', (x - 1) * grid.cellSize, (y - 1) * grid.cellSize, grid.cellSize, grid.cellSize)
    --     end
    -- end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    -- elseif key == 'space' then
    --     if grid.smoothGrid then
    --         grid:smoothGrid()
    --     end
    else
        grid = generatePerlinGrid()
    end
end

function generateCelAutGrid()
    love.math.setRandomSeed(os.time())
    local newGrid = CelAutMap{}

    -- for x = 1, newGrid.xSize do
    --     for y = 1, newGrid.ySize do
    --         newGrid[x][y] = love.math.random()
    --     end
    -- end

    return newGrid
end

function generatePerlinGrid()
    return PerlinMap{}
end