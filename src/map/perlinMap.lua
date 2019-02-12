local PerlinMap = Class:extend()

function PerlinMap:new(params)
    self.cellSize = params.cellSize or 5
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.scale = params.scale or 0.01
    self.xOff, self.yOff = params.xOff or 0.01, params.yOff or 0.01
    self:createGrid()
    self:initialiseGridValues()
end

function PerlinMap:createGrid()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
        end
    end
end

function PerlinMap:initialiseGridValues()
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            self[x][y] = love.math.noise((x * self.scale) + self.xOff, (y * self.scale) + self.yOff)
        end
    end
end

return PerlinMap