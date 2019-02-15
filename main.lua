require('src.utils.dependencies')

local grid

function love.load()
    -- grid = CelAutMap{}
    grid = PerlinMap{}
end

function love.update(dt)
    if grid.update then grid:update(dt) end
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
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif grid.keypressed then
        grid:keypressed(key)
    end
end