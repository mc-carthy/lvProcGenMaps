local CelAutMap = Class:extend()

function CelAutMap:new(params)
    self.cellSize = params.cellSize or 5
    self.xSize = params.xSize or love.graphics.getWidth() / self.cellSize
    self.ySize = params.ySize or love.graphics.getHeight() / self.cellSize
    self.smoothingIterations = params.smoothingIterations or 0
    self.fillPercentage = params.fillPercentage or 0.475

    self:createGrid()
    self:initialiseGridValues()
    -- for i = 0, self.smoothingIterations do
    --     self:smoothGrid()
    -- end
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
    for x = 1, self.xSize do
        for y = 1, self.ySize do
            if love.math.random() > self.fillPercentage then
                self[x][y] = 1
            else
                self[x][y] = 0
            end
        end
    end
end

function CelAutMap:smoothGrid()
    local mapBorderThickness = self.mapBorderThickness or 2
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

            if x <= mapBorderThickness or x > self.xSize - mapBorderThickness then
                self[x][y] = 0
            end

            if y <= mapBorderThickness or y > self.ySize - mapBorderThickness then
                self[x][y] = 0
            end

            if neighbourCount > 4 then
                self[x][y] = 0
            elseif neighbourCount < 4 then
                self[x][y] = 1
            end
        end
    end
end

return CelAutMap
