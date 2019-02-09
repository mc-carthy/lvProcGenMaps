local Grid = Class:extend()

function Grid:new(params)
    self.cellSize = params.cellSize or 20
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
        end
    end
end

return Grid