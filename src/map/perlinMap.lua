local PerlinMap = Class:extend()

function PerlinMap:new(params)
    self.seed = params.seed or os.time()
    self.numOctaves = 3
    love.math.setRandomSeed(self.seed)
    self.cellSize = params.cellSize or 1
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.scale = params.scale or 0.004
    self.xOff, self.yOff = love.math.random(10000), love.math.random(10000)
    self:createGrid()
    self:initialiseGridValues(self.seed)
    self:normaliseGridValues()
    self:roundGridValues(0.45)
end

function PerlinMap:createGrid()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = 0
        end
    end
end

function PerlinMap:initialiseGridValues(seed)
    for o = 0, self.numOctaves - 1 do
        for x = 1, self.xSize do
            for y = 1, self.ySize do
                self[x][y] = self[x][y] + (love.math.noise((x * (self.scale * (o + 1))) + self.xOff, (y * (self.scale * (o + 1))) + self.yOff)) * (0.5 ^ o)
            end
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

function PerlinMap:roundGridValues(threshold)
    local threshold = threshold or 0.5
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self[x][y] > threshold then self[x][y] = 1 end
            if self[x][y] < threshold then self[x][y] = 0 end
        end
    end
end

return PerlinMap