require('src.utils.dependencies')

local grid

function love.load()
    grid = generateGrid()
end

function love.update(dt)

end

function love.draw()
    for x = 1, grid.xSize do
        for y = 1, grid.ySize do
            love.graphics.setColor(grid[x][y], grid[x][y], grid[x][y])
            love.graphics.rectangle('fill', (x - 1) * grid.cellSize, (y - 1) * grid.cellSize, grid.cellSize, grid.cellSize)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        grid = generateGrid()
    end
end

function generateGrid()
    love.math.setRandomSeed(os.time())
    local newGrid = Grid{
        cellSize = 20
    }

    for x = 1, newGrid.xSize do
        for y = 1, newGrid.ySize do
            newGrid[x][y] = love.math.random()
        end
    end

    return newGrid
end