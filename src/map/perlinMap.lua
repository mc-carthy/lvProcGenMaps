local PerlinMap = Class:extend()

function PerlinMap:new(params)
    self.seed = params.seed or os.time()
    love.math.setRandomSeed(self.seed)
    self.cellSize = params.cellSize or 5
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.scale = params.scale or 0.01
    self.xOff, self.yOff = love.math.random(10000), love.math.random(10000)
    self:createGrid()
    self:initialiseGridValues(self.seed)
    self:normaliseGridValues()
end

function PerlinMap:createGrid()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = {}
        end
    end
end

function PerlinMap:initialiseGridValues(seed)
    self.seed = seed
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            self[x][y] = love.math.noise((x * self.scale) + self.xOff, (y * self.scale) + self.yOff)
        end
    end
end

function PerlinMap:normaliseGridValues()
    local min, max = math.huge, 0
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self[x][y] > max then max = self[x][y] end
            if self[x][y] < min then min = self[x][y] end
        end
    end
    
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            self[x][y] = (self[x][y] - min) / (max - min)
        end
    end
end

return PerlinMap