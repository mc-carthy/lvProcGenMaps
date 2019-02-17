local PerlinMap = Class:extend()

function PerlinMap:new(params)
    self.params = params or {}
    self.seed = params.seed or os.time()
    self.fillThreshold = params.fillThreshold or 0.65
    self.numOctaves = 4
    love.math.setRandomSeed(self.seed)
    self.cellSize = params.cellSize or 2
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.scale = params.scale or 0.01
    self.xOff, self.yOff = love.math.random(10000), love.math.random(10000)
    self.mapBorderSize = 5
    self.t = 0
    self.tScale = 1
    self:initialiseGridValues()
    self:normaliseGridValues()
    self:roundGridValues(self.fillThreshold)
end

function PerlinMap:update(dt)
    self.t = self.t + dt
    -- self:initialiseGridValues()
    -- self:normaliseGridValues()
    -- self:roundGridValues(0.7)
end

function PerlinMap:initialiseGridValues()
    for x = 1, self.xSize do
        self[x] = {}
        for y = 1, self.ySize do
            self[x][y] = 0
            for o = 0, self.numOctaves - 1 do
                self[x][y] =
                    self[x][y] +
                    (love.math.noise(
                        (x * (self.scale * self.cellSize * (o + 1))) + self.xOff,
                        (y * (self.scale * self.cellSize * (o + 1))) + self.yOff,
                        self.t * self.tScale
                    )) *
                        (0.5 ^ o)
            end
            if self:isBorderCell(x, y) then
                self[x][y] = 0
            end
        end
    end
end

function PerlinMap:normaliseGridValues()
    local min, max = math.huge, 0
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if self[x][y] > max then
                max = self[x][y]
            end
            if self[x][y] < min then
                min = self[x][y]
            end
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
            if self[x][y] < threshold or self:isBorderCell(x, y) then
                self[x][y] = 0
            else
                self[x][y] = 1
            end
        end
    end
end

function PerlinMap:isBorderCell(x, y)
    return x < self.mapBorderSize + 1 or x > self.xSize - (self.mapBorderSize + 1) or y < self.mapBorderSize + 1 or y > self.ySize - (self.mapBorderSize + 1)
end

function PerlinMap:keypressed(key)
    self = self:new(self.params)
end

return PerlinMap
